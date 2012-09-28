Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422698Ab2I1U1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:27:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032619Ab2I1U1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:27:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 116/218] dmaengine: at_hdmac: check that each sg data length is non-null
Date: Fri, 28 Sep 2012 13:15:33 -0700
Message-Id: <20120928201514.804713228@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit c456797681db814f4f5b36909e8e94047bf53d9c upstream.

Avoid the construction of a malformed DMA request sent to
the DMA controller.
Log message is for debug only because this condition is unlikely to
append and may only trigger at driver development time.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/at_hdmac.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -691,6 +691,11 @@ atc_prep_slave_sg(struct dma_chan *chan,
 
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
+			if (unlikely(!len)) {
+				dev_dbg(chan2dev(chan),
+					"prep_slave_sg: sg(%d) data length is zero\n", i);
+				goto err;
+			}
 			mem_width = 2;
 			if (unlikely(mem & 3 || len & 3))
 				mem_width = 0;
@@ -726,6 +731,11 @@ atc_prep_slave_sg(struct dma_chan *chan,
 
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
+			if (unlikely(!len)) {
+				dev_dbg(chan2dev(chan),
+					"prep_slave_sg: sg(%d) data length is zero\n", i);
+				goto err;
+			}
 			mem_width = 2;
 			if (unlikely(mem & 3 || len & 3))
 				mem_width = 0;
@@ -759,6 +769,7 @@ atc_prep_slave_sg(struct dma_chan *chan,
 
 err_desc_get:
 	dev_err(chan2dev(chan), "not enough descriptors available\n");
+err:
 	atc_desc_put(atchan, first);
 	return NULL;
 }


