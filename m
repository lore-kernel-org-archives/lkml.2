Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1FPHLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:11:46 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:32875 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757072Ab1FPHLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:35 -0400
X-Sasl-enc: VrxlZ1WFJeYc7tArOO33GEDYcZot3C/qiWoQyLnyp0Ps 1308208294
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:11 2011
Message-Id: <20110616002911.783094323@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [79/85] pata_cmd64x: cmd648_bmdma_stop() fix
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 03a849e6ddb604ff6a220b78637ee8e122ffc796 upstream.

Clear the primary channel pending interrupt bit
instead of the reserved one.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_cmd64x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -40,7 +40,7 @@
 
 enum {
 	CFR 		= 0x50,
-		CFR_INTR_CH0  = 0x02,
+		CFR_INTR_CH0  = 0x04,
 	CNTRL 		= 0x51,
 		CNTRL_DIS_RA0 = 0x40,
 		CNTRL_DIS_RA1 = 0x80,


