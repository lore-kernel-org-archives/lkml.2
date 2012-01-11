Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab2AKBLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 20:11:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54134 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab2AKBLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:11:51 -0500
Date: Wed, 11 Jan 2012 05:11:46 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH] x86: Get rid of 'dubious one-bit signed bitfield' sprase
 warning
Message-ID: <20120111011146.GA30428@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This very noisy sparse warning appears on almost every file in the
kernel:

  CHECK   init/main.c
arch/x86/include/asm/thread_info.h:43:55: error: dubious one-bit signed bitfield
arch/x86/include/asm/thread_info.h:44:46: error: dubious one-bit signed bitfield

This patch changes sig_on_uaccess_error and uaccess_err flags to unsigned
type and thus fixes the warning.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

Not sure why this warning is still there, as it spams the build process
a lot. I googled some discussion dated month ago... but no one sent a
patch?

http://www.spinics.net/lists/linux-kernel-janitors/msg10172.html

I went safest way, i.e. changing types to unsigned instead of bool/__u8.

 arch/x86/include/asm/thread_info.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 7404715..bc817cd 100644
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
-- 
1.7.7.3
