Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab3AJRMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:12:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab3AJRMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:12:09 -0500
From: Miroslav Lichvar <mlichvar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: [PATCH] posix-timers: Fix clock_adjtime to return timex data on success
Date: Thu, 10 Jan 2013 18:12:02 +0100
Message-Id: <1357837922-1555-1-git-send-email-mlichvar@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy the modified timex data back to the user also with positive return
values. This fixes reading of the CLOCK_REALTIME timex data when the
clock is in a non-zero state.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
---
 kernel/posix-timers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 69185ae..10349d5 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -997,7 +997,7 @@ SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
 
 	err = kc->clock_adj(which_clock, &ktx);
 
-	if (!err && copy_to_user(utx, &ktx, sizeof(ktx)))
+	if (err >= 0 && copy_to_user(utx, &ktx, sizeof(ktx)))
 		return -EFAULT;
 
 	return err;
-- 
1.7.11.7

