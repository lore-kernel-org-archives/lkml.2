Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2HPAd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 20:33:59 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:33702 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab2HPAd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 20:33:58 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1345077233!7029745!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] staging: comedi: contec_pci_dio: cleanup contec_do_insn_bits
Date: Wed, 15 Aug 2012 17:32:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208151732.53366.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create local variables for the mask and bits values passed in
the data pointer to make this function a bit clearer.

Return the state of the output bits (s->state) in data[1] since
this is what comedilib is expecting.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index b7b60d3..12ad9fa3 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -44,12 +44,18 @@ static int contec_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (data[0]) {
-		s->state &= ~data[0];
-		s->state |= data[0] & data[1];
+	unsigned int mask = data[0];
+	unsigned int bits = data[1];
+
+	if (mask) {
+		s->state &= ~mask;
+		s->state |= (bits & mask);
 
 		outw(s->state, dev->iobase + PIO1616L_DO_REG);
 	}
+
+	data[1] = s->state;
+
 	return insn->n;
 }
 
-- 
1.7.11

