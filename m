Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2BZD7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 22:59:43 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40575 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2BZD7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 22:59:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bobbypowers@gmail.com designates 10.224.106.194 as permitted sender) smtp.mail=bobbypowers@gmail.com; dkim=pass header.i=bobbypowers@gmail.com
From: Bobby Powers <bobbypowers@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        Bobby Powers <bobbypowers@gmail.com>
Subject: [PATCH] x32: only clear TIF_X32 flag once
Date: Sat, 25 Feb 2012 22:59:34 -0500
Message-Id: <1330228774-24223-1-git-send-email-bobbypowers@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits bb212724 and d1a797f3 both added a call to
clear_thread_flag(TIF_X32) under set_personality_64bit() - only one is
needed.

Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
---
 arch/x86/kernel/process_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index a0701da..e9ec8f1 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -510,7 +510,6 @@ void set_personality_64bit(void)
 
 	/* Make sure to be in 64bit mode */
 	clear_thread_flag(TIF_IA32);
-	clear_thread_flag(TIF_X32);
 	clear_thread_flag(TIF_ADDR32);
 	clear_thread_flag(TIF_X32);
 
-- 
1.7.7.6

