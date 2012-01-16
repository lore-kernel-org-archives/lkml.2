Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2APJEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:04:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45082 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2APJEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:04:53 -0500
Date: Mon, 16 Jan 2012 01:04:36 -0800
From: tip-bot for Anton Vorontsov <cbouatmailru@gmail.com>
Message-ID: <tip-f10448689d95b9516c656ccd4078839e656656e7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, torvalds@linux-foundation.org, error27@gmail.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu,
        cbouatmailru@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, torvalds@linux-foundation.org, error27@gmail.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu,
        cbouatmailru@gmail.com
In-Reply-To: <20120111011146.GA30428@oksana.dev.rtsoft.ru>
References: <20120111011146.GA30428@oksana.dev.rtsoft.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Get rid of dubious one-bit signed bitfield
Git-Commit-ID: f10448689d95b9516c656ccd4078839e656656e7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 16 Jan 2012 01:04:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f10448689d95b9516c656ccd4078839e656656e7
Gitweb:     http://git.kernel.org/tip/f10448689d95b9516c656ccd4078839e656656e7
Author:     Anton Vorontsov <cbouatmailru@gmail.com>
AuthorDate: Wed, 11 Jan 2012 05:11:46 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Jan 2012 09:39:54 +0100

x86: Get rid of dubious one-bit signed bitfield

This very noisy sparse warning appears on almost every file in
the kernel:

  CHECK   init/main.c
  arch/x86/include/asm/thread_info.h:43:55: error: dubious one-bit
  signed bitfield arch/x86/include/asm/thread_info.h:44:46: error:
  dubious one-bit signed bitfield

Sparse is right and this patch changes sig_on_uaccess_error and
uaccess_err flags to unsigned type and thus fixes the warning.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Andy Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Dan Carpenter <error27@gmail.com>
Link: http://lkml.kernel.org/r/20120111011146.GA30428@oksana.dev.rtsoft.ru
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/thread_info.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 185b719..56a63ff 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -40,8 +40,8 @@ struct thread_info {
 						*/
 	__u8			supervisor_stack[0];
 #endif
-	int			sig_on_uaccess_error:1;
-	int			uaccess_err:1;	/* uaccess failed */
+	unsigned int		sig_on_uaccess_error:1;
+	unsigned int		uaccess_err:1;	/* uaccess failed */
 };
 
 #define INIT_THREAD_INFO(tsk)			\
