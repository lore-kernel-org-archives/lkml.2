Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab1BDMXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:23:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab1BDMXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:23:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ft/uzWrjDHoZk+SILphw37Nzn6WKU8N7adQMrY6yW7G9IO6EdWFLmPkJjswpEfFr45
         72qu5RcI09Y8y7ntBm1OhMLbijYNYkt7T31iJ5K07xtozAZ/fQ2Tjl82NBCXlmz4TeZC
         7hpoB0lfCbyRtqdXrnl2ypUidAWnJ1nZgikno=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 10/20] mfd: ab8500: world-writable debugfs register-* files
Date: Fri,  4 Feb 2011 15:23:43 +0300
Message-Id: <c8f28aeecd5f4d05b9ae0b110831aa128754f172.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to interact with hardware registers.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/mfd/ab8500-debugfs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 3c1541a..64748e4 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -585,18 +585,18 @@ static int __devinit ab8500_debug_probe(struct platform_device *plf)
 		goto exit_destroy_dir;
 
 	ab8500_bank_file = debugfs_create_file("register-bank",
-		(S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev, &ab8500_bank_fops);
+		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev, &ab8500_bank_fops);
 	if (!ab8500_bank_file)
 		goto exit_destroy_reg;
 
 	ab8500_address_file = debugfs_create_file("register-address",
-		(S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev,
+		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev,
 		&ab8500_address_fops);
 	if (!ab8500_address_file)
 		goto exit_destroy_bank;
 
 	ab8500_val_file = debugfs_create_file("register-value",
-		(S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev, &ab8500_val_fops);
+		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev, &ab8500_val_fops);
 	if (!ab8500_val_file)
 		goto exit_destroy_address;
 
-- 
1.7.0.4

