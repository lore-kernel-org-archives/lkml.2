Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0HDEpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:45:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48551 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab0HDEp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=DkinMmQJJXd3VsHmJlbuMpmeMlVBpRTzgdeJbug/gqrhJlmjItl9/EH8gjC0qhWy7d
         JoJscCgBO53TnCDGoZqon56RrZQBqiJxGCZv8fiHl9zo0KfXLNSK6M4PnWiAVbp05CTT
         cb+fv3K6Ilce51Gq4Ux/2CepNxWXunzzZs4mY=
Subject: [PATCH] staging/rt2860: fix bad dma_addr_t conversion
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, Gorskin Ilya <revent82@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 00:45:19 -0400
Message-ID: <1280897119.4986.16.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA addresses are not pointers and shouldn't be assigned to NULL.
This patch was generated against today linux-next.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/rt2860/rt_pci_rbus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2860/rt_pci_rbus.c b/drivers/staging/rt2860/rt_pci_rbus.c
index 3004be6..244c754 100644
--- a/drivers/staging/rt2860/rt_pci_rbus.c
+++ b/drivers/staging/rt2860/rt_pci_rbus.c
@@ -218,7 +218,7 @@ void *RTMP_AllocateRxPacketBuffer(struct rt_rtmp_adapter *pAd,
 				   PCI_DMA_FROMDEVICE);
 	} else {
 		*VirtualAddress = (void *)NULL;
-		*PhysicalAddress = (dma_addr_t)NULL;
+		*PhysicalAddress = 0;
 	}
 
 	return (void *)pkt;
-- 
1.7.0.4



