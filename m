Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2HPAbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 20:31:46 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:23902 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2HPAbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 20:31:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1345077103!5857740!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] staging: comedi: contec_pci_dio: define register map for board
Date: Wed, 15 Aug 2012 17:31:39 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208151731.40096.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one board type is supported by this driver. Instead of
passing the register offsets for the digital in/out ports in
the boardinfo, define the register map and use that to access
the ports.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 24427ca..698d05b 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -42,26 +42,28 @@ enum contec_model {
 
 struct contec_board {
 	const char *name;
-	int in_offs;
-	int out_offs;
 };
 static const struct contec_board contec_boards[] = {
-	{"PIO1616L", 0, 2 },
+	{"PIO1616L", },
 };
 
 #define PCI_DEVICE_ID_PIO1616L 0x8172
 
+/*
+ * Register map
+ */
+#define PIO1616L_DI_REG		0x00
+#define PIO1616L_DO_REG		0x02
+
 static int contec_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	const struct contec_board *thisboard = comedi_board(dev);
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
 
-		outw(s->state, dev->iobase + thisboard->out_offs);
+		outw(s->state, dev->iobase + PIO1616L_DO_REG);
 	}
 	return insn->n;
 }
@@ -70,9 +72,7 @@ static int contec_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	const struct contec_board *thisboard = comedi_board(dev);
-
-	data[1] = inw(dev->iobase + thisboard->in_offs);
+	data[1] = inw(dev->iobase + PIO1616L_DI_REG);
 
 	return insn->n;
 }
-- 
1.7.11

