Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2KSFbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:31:53 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45275 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2KSFbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:31:51 -0500
X-Originating-IP: 217.70.178.150
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>, Josh Triplett <josh@joshtriplett.org>,
        Ingo Molnar <mingo@elte.hu>, Diwakar Tundlam <dtundlam@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 41/58] init/calibrate.c: Add prototype for __weak stub of calibrate_delay_is_known
Date: Sun, 18 Nov 2012 21:28:20 -0800
Message-Id: <1353302917-13995-42-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init/calibrate.c defines an empty stub of calibrate_delay_is_known with
__attribute__((weak)), for use on architectures without an alternate
implementation.  Define a prototype of that function, to satisfy gcc
(-Wmissing-prototypes) and Sparse (-Wdecl).

init/calibrate.c:257:150: warning: no previous prototype for ‘calibrate_delay_is_known’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 init/calibrate.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/init/calibrate.c b/init/calibrate.c
index fda0a7b..7177627 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -254,6 +254,7 @@ static DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
  * Architectures should override this function if a faster calibration
  * method is available.
  */
+unsigned long calibrate_delay_is_known(void);
 unsigned long __attribute__((weak)) __cpuinit calibrate_delay_is_known(void)
 {
 	return 0;
-- 
1.7.10.4

