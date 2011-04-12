Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab1DLOnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:43:50 -0400
Received: from kroah.org ([198.145.64.141]:57780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412Ab1DLOiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:57 2011
Message-Id: <20110412143557.144755710@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [086/105] mfd: ab3500: world-writable debugfs register-* files
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 90c861c2a83d974684974441093ff8a50e6b430b upstream.

Don't allow everybody to interact with hardware registers.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/ab3550-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -1053,17 +1053,17 @@ static inline void ab3550_setup_debugfs(
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
 


