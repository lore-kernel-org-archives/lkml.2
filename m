Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1BQP4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:56:11 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:57994 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1BQP4I convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 17 Feb 2011 10:56:08 -0500
Message-Id: <4D5D535A0200007800032730@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 17 Feb 2011 15:56:58 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: combine printk()s in show_regs_common()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing a single character alone when there's an immediately following
printk() is pretty pointless (and wasteful).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/process.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- 2.6.38-rc5/arch/x86/kernel/process.c
+++ 2.6.38-rc5-x86-show-regs-fold-printks/arch/x86/kernel/process.c
@@ -110,12 +110,9 @@ void show_regs_common(void)
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	printk(KERN_CONT " ");
-	printk(KERN_CONT "%s %s", vendor, product);
-	if (board) {
-		printk(KERN_CONT "/");
-		printk(KERN_CONT "%s", board);
-	}
+	printk(KERN_CONT " %s %s", vendor, product);
+	if (board)
+		printk(KERN_CONT "/%s", board);
 	printk(KERN_CONT "\n");
 }
 



