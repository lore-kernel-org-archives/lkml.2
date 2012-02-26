Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2BZFv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 00:51:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39891 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2BZFvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 00:51:48 -0500
Date: Sat, 25 Feb 2012 21:51:22 -0800
From: tip-bot for Bobby Powers <bobbypowers@gmail.com>
Message-ID: <tip-00194b2e845da29395ad00c13a884d9acb9306b5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bobbypowers@gmail.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, bobbypowers@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1330228774-24223-1-git-send-email-bobbypowers@gmail.com>
References: <1330228774-24223-1-git-send-email-bobbypowers@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x32: Only clear TIF_X32 flag once
Git-Commit-ID: 00194b2e845da29395ad00c13a884d9acb9306b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 25 Feb 2012 21:51:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00194b2e845da29395ad00c13a884d9acb9306b5
Gitweb:     http://git.kernel.org/tip/00194b2e845da29395ad00c13a884d9acb9306b5
Author:     Bobby Powers <bobbypowers@gmail.com>
AuthorDate: Sat, 25 Feb 2012 22:59:34 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 25 Feb 2012 20:42:23 -0800

x32: Only clear TIF_X32 flag once

Commits bb212724 and d1a797f3 both added a call to
clear_thread_flag(TIF_X32) under set_personality_64bit() - only one is
needed.

Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
Link: http://lkml.kernel.org/r/1330228774-24223-1-git-send-email-bobbypowers@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/process_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 32e0412..a465973 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -510,7 +510,6 @@ void set_personality_64bit(void)
 
 	/* Make sure to be in 64bit mode */
 	clear_thread_flag(TIF_IA32);
-	clear_thread_flag(TIF_X32);
 	clear_thread_flag(TIF_ADDR32);
 	clear_thread_flag(TIF_X32);
 
