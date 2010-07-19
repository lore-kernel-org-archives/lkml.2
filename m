Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965919Ab0GSSkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:40:20 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26617 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965703Ab0GSSkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:05 -0400
Subject: [PATCH 11/26] cciss: factor out CISS_signature_present()
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:36 -0500
Message-ID: <20100719184536.7908.57654.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: factor out CISS_signature_present()

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 97feb50..9a48695 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4096,6 +4096,18 @@ static void __devinit cciss_find_board_params(ctlr_info_t *h)
 	}
 }
 
+static inline bool CISS_signature_present(ctlr_info_t *h)
+{
+	if ((readb(&h->cfgtable->Signature[0]) != 'C') ||
+	    (readb(&h->cfgtable->Signature[1]) != 'I') ||
+	    (readb(&h->cfgtable->Signature[2]) != 'S') ||
+	    (readb(&h->cfgtable->Signature[3]) != 'S')) {
+		dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
+		return false;
+	}
+	return true;
+}
+
 static int __devinit cciss_pci_init(ctlr_info_t *c)
 {
 	int prod_index, err;
@@ -4153,11 +4165,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 #endif				/* CCISS_DEBUG */
 	cciss_find_board_params(c);
 
-	if ((readb(&c->cfgtable->Signature[0]) != 'C') ||
-	    (readb(&c->cfgtable->Signature[1]) != 'I') ||
-	    (readb(&c->cfgtable->Signature[2]) != 'S') ||
-	    (readb(&c->cfgtable->Signature[3]) != 'S')) {
-		printk("Does not appear to be a valid CISS config table\n");
+	if (!CISS_signature_present(c)) {
 		err = -ENODEV;
 		goto err_out_free_res;
 	}

