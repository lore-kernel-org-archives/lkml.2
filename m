Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab1FPHNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:13:53 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:32996 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757063Ab1FPHLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:33 -0400
X-Sasl-enc: lYPU+4kaCfH9yXLaVJpAgrUDne4NpAx30tAm6pnEE3hC 1308208292
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:11 2011
Message-Id: <20110616002911.682941603@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [78/85] pata_cmd64x: fix PIO setup
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit a2bd62207af4be8f5fe815ff90cc309056407829 upstream.

Fix incorrect handling of recovery clocks value == 16 resulting
in overclocked recovery timings & potentially underclocked active
timings.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_cmd64x.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -2,6 +2,7 @@
  * pata_cmd64x.c 	- CMD64x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
+ *			  (C) 2009-2010 Bartlomiej Zolnierkiewicz
  *
  * Based upon
  * linux/drivers/ide/pci/cmd64x.c		Version 1.30	Sept 10, 2002
@@ -147,7 +148,9 @@ static void cmd64x_set_timing(struct ata
 	/* Now convert the clocks into values we can actually stuff into
 	   the chip */
 
-	if (t.recover > 1)
+	if (t.recover == 16)
+		t.recover = 0;
+	else if (t.recover > 1)
 		t.recover--;
 	else
 		t.recover = 15;


