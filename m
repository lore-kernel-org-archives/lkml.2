Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1FTXZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:25:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50686 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab1FTXZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:25:04 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@chromium.org>, Olaf Hering <olaf@aepfle.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@gmail.com>
Subject: [PATCH 2/2] panic: do not unblank_screen when panic_timeout < 0
Date: Mon, 20 Jun 2011 16:22:09 -0700
Message-Id: <1308612129-12488-2-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1308612129-12488-1-git-send-email-msb@chromium.org>
References: <1308612129-12488-1-git-send-email-msb@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid risk (of screen_unblank) and wasted cycles unblanking if
you intend to reboot immediately.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@chromium.org>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>
---
 lib/bust_spinlocks.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/bust_spinlocks.c b/lib/bust_spinlocks.c
index 9681d54..6a5c7e0 100644
--- a/lib/bust_spinlocks.c
+++ b/lib/bust_spinlocks.c
@@ -21,7 +21,8 @@ void __attribute__((weak)) bust_spinlocks(int yes)
 		++oops_in_progress;
 	} else {
 #ifdef CONFIG_VT
-		unblank_screen();
+		if (panic_timeout >= 0)
+			unblank_screen();
 #endif
 		console_unblank();
 		if (--oops_in_progress == 0)
-- 
1.7.3.1

