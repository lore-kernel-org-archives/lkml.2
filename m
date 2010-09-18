Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0IRTjr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:39:47 -0400
Received: from kroah.org ([198.145.64.141]:43176 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626Ab0IRTOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:46 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:58 2010
Message-Id: <20100918191258.121261712@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:11:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Lord <mlord@pobox.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [010/129] libata-sff: remove harmful BUG_ON from ata_bmdma_qc_issue
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Lord <kernel@teksavvy.com>

commit 55ee67f837882f28a900705a2ca1af257ab6c53d upstream.

Remove harmful BUG_ON() from ata_bmdma_qc_issue(),
as it casts too wide of a net and breaks sata_mv.
It also crashes the kernel while doing the BUG_ON().

There's already a WARN_ON_ONCE() further down to catch
the case of POLLING for a BMDMA operation.

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-sff.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2735,10 +2735,6 @@ unsigned int ata_bmdma_qc_issue(struct a
 {
 	struct ata_port *ap = qc->ap;
 
-	/* see ata_dma_blacklisted() */
-	BUG_ON((ap->flags & ATA_FLAG_PIO_POLLING) &&
-	       qc->tf.protocol == ATAPI_PROT_DMA);
-
 	/* defer PIO handling to sff_qc_issue */
 	if (!ata_is_dma(qc->tf.protocol))
 		return ata_sff_qc_issue(qc);


