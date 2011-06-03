Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1FCXaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:30:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:58560 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab1FCXaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:30:12 -0400
Date: Fri, 3 Jun 2011 23:30:05 GMT
From: tip-bot for Borislav Petkov <bp@alien8.de>
Message-ID: <tip-dd2897bf0f4d523238e87dabb23e9634ea9ba73d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, bp@alien8.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, hpa@linux.intel.com
In-Reply-To: <1307131642-32595-1-git-send-email-bp@alien8.de>
References: <1307131642-32595-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, asm: Fix binutils 2.16 issue with __USER32_CS
Git-Commit-ID: dd2897bf0f4d523238e87dabb23e9634ea9ba73d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 23:30:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd2897bf0f4d523238e87dabb23e9634ea9ba73d
Gitweb:     http://git.kernel.org/tip/dd2897bf0f4d523238e87dabb23e9634ea9ba73d
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Fri, 3 Jun 2011 22:07:22 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 3 Jun 2011 14:39:14 -0700

x86, asm: Fix binutils 2.16 issue with __USER32_CS

While testing the patchset at

http://lkml.kernel.org/r/1306873314-32523-1-git-send-email-bp@alien8.de

with binutils 2.16.1 from hell, kernel build fails with the following
error:

arch/x86/ia32/ia32entry.S: Assembler messages:
arch/x86/ia32/ia32entry.S:139: Error: too many positional arguments
make[2]: *** [arch/x86/ia32/ia32entry.o] Error 1
make[1]: *** [arch/x86/ia32] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [arch/x86] Error 2
make: *** Waiting for unfinished jobs....

due to spaces between the operators of the __USER32_CS define. Fix it so
that gas 2.16 can swallow it too.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1307131642-32595-1-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/segment.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index cd84f72..5e64171 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -162,7 +162,7 @@
 #define GDT_ENTRY_DEFAULT_USER32_CS 4
 #define GDT_ENTRY_DEFAULT_USER_DS 5
 #define GDT_ENTRY_DEFAULT_USER_CS 6
-#define __USER32_CS   (GDT_ENTRY_DEFAULT_USER32_CS * 8 + 3)
+#define __USER32_CS   (GDT_ENTRY_DEFAULT_USER32_CS*8+3)
 #define __USER32_DS	__USER_DS
 
 #define GDT_ENTRY_TSS 8	/* needs two entries */
