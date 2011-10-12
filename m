Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1JLP2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:28:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63883 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab1JLP2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:28:44 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_scc: add proper cable detection method
Date: Wed, 12 Oct 2011 17:16:37 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kou Ishizaki <kou.ishizaki@toshiba.co.jp>,
        Akira Iguchi <akira2.iguchi@toshiba.co.jp>
References: <201110112007.24530.bzolnier@gmail.com> <20111011205415.1d5708af@lxorguk.ukuu.org.uk>
In-Reply-To: <20111011205415.1d5708af@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <201110121716.37990.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> On Tue, 11 Oct 2011 20:07:24 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] pata_scc: add proper cable detection method
> > 
> > Use standard ata_cable_80wire() method for the cable detection,
> > as a bonus this allows us to use the default ->prereset method.
> 
> What documentation have you got that confirms that the hardcoding is not
> needed. It goes back to the original code and I see nothing saying that
> the device has standard PC style cable detect.

The driver predates standard cable detect routines and open-codes its
own one.  There should be no functionality changes caused by this patch.

Commit a619f981b ("libata: PATA driver for Celleb") is from Jan 2007
while ata_cable_80wire() was added by commit be0d18d ("libata: cable
detection fixes") in Mar 2007.

> You should also I think cc the Toshiba maintainers

added to cc:.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_scc: add proper cable detection method

Use standard ata_cable_80wire() method for the cable detection,
as a bonus this allows us to use the default ->prereset method.

Cc: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Cc: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/373

 drivers/ata/pata_scc.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

Index: b/drivers/ata/pata_scc.c
===================================================================
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -827,18 +827,6 @@ static unsigned int scc_data_xfer (struc
 }
 
 /**
- *	scc_pata_prereset - prepare for reset
- *	@ap: ATA port to be reset
- *	@deadline: deadline jiffies for the operation
- */
-
-static int scc_pata_prereset(struct ata_link *link, unsigned long deadline)
-{
-	link->ap->cbl = ATA_CBL_PATA80;
-	return ata_sff_prereset(link, deadline);
-}
-
-/**
  *	scc_postreset - standard postreset callback
  *	@ap: the target ata_port
  *	@classes: classes of attached devices
@@ -947,7 +935,7 @@ static struct ata_port_operations scc_pa
 	.bmdma_status		= scc_bmdma_status,
 	.sff_data_xfer		= scc_data_xfer,
 
-	.prereset		= scc_pata_prereset,
+	.cable_detect		= ata_cable_80wire,
 	.softreset		= scc_softreset,
 	.postreset		= scc_postreset,
 
