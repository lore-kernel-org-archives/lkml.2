Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0EQRST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:18:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:4772 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab0EQRSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:18:18 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 1/3] posix_timer: remove wrong comment
Date: Mon, 17 May 2010 21:18:06 +0400
Message-Id: <1274116688-4037-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

currently "The next step is hard to back out if there is an error."
comment is not right, release_posix_timer() does put_pid().

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/posix-timers.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 00d1fda..5555e7c 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -563,10 +563,6 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	if (error)
 		goto out;
 
-	/*
-	 * return the timer_id now.  The next step is hard to
-	 * back out if there is an error.
-	 */
 	if (copy_to_user(created_timer_id,
 			 &new_timer_id, sizeof (new_timer_id))) {
 		error = -EFAULT;
-- 
1.6.6

