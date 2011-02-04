Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab1BDM0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:26:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1BDMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:23:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=erJ4veY4mXyU2O/Ytn91gDcDuqoxCiUKa8uoqOyTkE5FxZtNNsxeN3okNhQNPlMr3O
         zm3yRZSUWIttPaKKg/xX0b46niOD4GN9JZBufh1ypBxwCCMu6zX+Eh44yZH95t6RAbax
         B9MgAUSOzYCORtZtEzOuxf/e2RTO3Ilpce6io=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 09/20] mfd: ab3500: world-writable debugfs register-* files
Date: Fri,  4 Feb 2011 15:23:39 +0300
Message-Id: <f67e210975afa7122a9bfe5e6c84ea84366a399f.1296818921.git.segoon@openwall.com>
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

 drivers/mfd/ab3550-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
index 5fbca34..681984d 100644
--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -1053,17 +1053,17 @@ static inline void ab3550_setup_debugfs(struct ab3550 *ab)
 		goto exit_destroy_dir;
 
 	ab3550_bank_file = debugfs_create_file("register-bank",
-		(S_IRUGO | S_IWUGO), ab3550_dir, ab, &ab3550_bank_fops);
+		(S_IRUGO | S_IWUSR), ab3550_dir, ab, &ab3550_bank_fops);
 	if (!ab3550_bank_file)
 		goto exit_destroy_reg;
 
 	ab3550_address_file = debugfs_create_file("register-address",
-		(S_IRUGO | S_IWUGO), ab3550_dir, ab, &ab3550_address_fops);
+		(S_IRUGO | S_IWUSR), ab3550_dir, ab, &ab3550_address_fops);
 	if (!ab3550_address_file)
 		goto exit_destroy_bank;
 
 	ab3550_val_file = debugfs_create_file("register-value",
-		(S_IRUGO | S_IWUGO), ab3550_dir, ab, &ab3550_val_fops);
+		(S_IRUGO | S_IWUSR), ab3550_dir, ab, &ab3550_val_fops);
 	if (!ab3550_val_file)
 		goto exit_destroy_address;
 
-- 
1.7.0.4

