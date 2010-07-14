Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab0GNSBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:01:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54111 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab0GNSBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ErIf5cLKYE+joEmfAxUfzZE4avmThu8wJ2QM249EhjjphEZKVXD5mkPAchPhonLFi4
         f39B0sY/DXjAdfSs971If7+b7RTVljY3uwJ/l6+OufEzhZljFWFH2/BxqW8WCoZZqCdQ
         3WHB+ahseRlGhHAYhOmbRjIlcK4mx5q0avpsQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] arch/h8300/kernel/traps.c: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 22:00:42 +0400
Message-Id: <1279130442-10695-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/h8300/kernel/traps.c |    4 +++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index 3c0b66b..2c6270f 100644
--- a/arch/h8300/kernel/traps.c
+++ b/arch/h8300/kernel/traps.c
@@ -77,7 +78,7 @@ static void dump(struct pt_regs *fp)
 	tp = ((unsigned char *) fp->pc) - 0x20;
 	for (sp = (unsigned long *) tp, i = 0; (i < 0x40);  i += 4) {
 		if ((i % 0x10) == 0)
-			printk("\n%08x: ", (int) (tp + i));
+			printk("\n%p: ", tp + i);
 		printk("%08x ", (int) *sp++);
 	}
 	printk("\n");
@@ -86,7 +87,7 @@ static void dump(struct pt_regs *fp)
 	tp = ((unsigned char *) fp) - 0x40;
 	for (sp = (unsigned long *) tp, i = 0; (i < 0xc0); i += 4) {
 		if ((i % 0x10) == 0)
-			printk("\n%08x: ", (int) (tp + i));
+			printk("\n%p: ", tp + i);
 		printk("%08x ", (int) *sp++);
 	}
 	printk("\n");
-- 
1.7.0.4

