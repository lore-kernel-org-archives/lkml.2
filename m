Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2KSFbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:31:47 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50073 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2KSFbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:31:44 -0500
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vikram Mulukutla <markivx@codeaurora.org>,
        Ben Hutchings <ben@decadent.org.uk>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 40/58] panic: Add prototype for __weak stub of panic_smp_self_stop
Date: Sun, 18 Nov 2012 21:28:19 -0800
Message-Id: <1353302917-13995-41-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/panic.c defines an empty stub of panic_smp_self_stop with __weak,
for use on architectures without an alternate implementation.  Define a
prototype of that function, to satisfy gcc (-Wmissing-prototypes) and
Sparse (-Wdecl).

kernel/panic.c:55:28: warning: no previous prototype for ‘panic_smp_self_stop’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/panic.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/panic.c b/kernel/panic.c
index e1b2822..38a4ed4 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -52,6 +52,7 @@ EXPORT_SYMBOL(panic_blink);
 /*
  * Stop ourself in panic -- architecture code may override this
  */
+void panic_smp_self_stop(void);
 void __weak panic_smp_self_stop(void)
 {
 	while (1)
-- 
1.7.10.4

