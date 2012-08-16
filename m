Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2HPAbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 20:31:00 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:43109 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab2HPAa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 20:30:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1345077056!7569297!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] staging: comedi: contec_pci_dio: remove function trace messages
Date: Wed, 15 Aug 2012 17:30:50 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208151730.50849.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_dbg function trace messages in the contec_do_insn_bits
and contec_di_insn_bits functions are just noise. Remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 71b7266..387dd42 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -61,14 +61,10 @@ static int contec_do_insn_bits(struct comedi_device *dev,
 {
 	const struct contec_board *thisboard = comedi_board(dev);
 
-	dev_dbg(dev->class_dev, "contec_do_insn_bits called\n");
-	dev_dbg(dev->class_dev, "data: %d %d\n", data[0], data[1]);
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
-		dev_dbg(dev->class_dev, "out: %d on %lx\n", s->state,
-			dev->iobase + thisboard->out_offs);
+
 		outw(s->state, dev->iobase + thisboard->out_offs);
 	}
 	return insn->n;
@@ -80,9 +76,6 @@ static int contec_di_insn_bits(struct comedi_device *dev,
 {
 	const struct contec_board *thisboard = comedi_board(dev);
 
-	dev_dbg(dev->class_dev, "contec_di_insn_bits called\n");
-	dev_dbg(dev->class_dev, "data: %d %d\n", data[0], data[1]);
-
 	data[1] = inw(dev->iobase + thisboard->in_offs);
 
 	return insn->n;
-- 
1.7.11

