Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab1DLOiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:38:50 -0400
Received: from kroah.org ([198.145.64.141]:57774 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab1DLOip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:57 2011
Message-Id: <20110412143557.046968936@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [085/105] mfd: ab8500: world-writable debugfs register-* files
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 44bdcb54df2714da18c4a0c6f711a350ab4ed93c upstream.

Don't allow everybody to interact with hardware registers.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/ab8500-debugfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -585,18 +585,18 @@ static int __devinit ab8500_debug_probe(
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
 


