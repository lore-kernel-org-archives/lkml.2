Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab0JSM2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 08:28:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61606 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235Ab0JSM2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:28:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=DOGxuY+XdT5xBU7KuQTOR8RfqEItBAgD+OlD5JCm9vLLRDa+Vn8VFM2nitdbWPp+Nw
         iqT7zpkVqoj3EtUDieHTS+yIBA0HS6GpoBXWp/7AZ+PbAASwJG8tKOPuHTCCF9eBf7PJ
         mJwkOh7M5TrssfajY/nlOR9oRRI0dYcXyBCpg=
Subject: [PATCH] mfd: Fix ezx_pcap_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Harald Welte <laforge@openezx.org>,
        Daniel Ribeiro <drwyrm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 20:28:24 +0800
Message-ID: <1287491304.2457.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return -ENOMEM if create_singlethread_workqueue failed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/ezx-pcap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index d283d77..c2b698d 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -465,6 +465,7 @@ static int __devinit ezx_pcap_probe(struct spi_device *spi)
 	pcap->irq_base = pdata->irq_base;
 	pcap->workqueue = create_singlethread_workqueue("pcapd");
 	if (!pcap->workqueue) {
+		ret = -ENOMEM;
 		dev_err(&spi->dev, "cant create pcap thread\n");
 		goto free_pcap;
 	}
-- 
1.7.0.4



