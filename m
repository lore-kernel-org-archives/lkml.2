Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2HOBZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 21:25:23 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:16320 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab2HOBZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 21:25:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1344993919!13241772!3
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] staging: comedi: dnya_pci10xx: cleanup the analog output range
Date: Tue, 14 Aug 2012 18:24:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208141824.20266.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The analog output channels on this board only support a single
range, 0-10V unipolar. This range is available as an exported
symbol from the comedi core and "range_unipolar10". Use that
instead of duplicating the range in this driver and remove
the information from the boardinfo.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 15048aa..abfbb12 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -54,13 +54,6 @@ static const struct comedi_lrange range_pci1050_ai = { 3, {
 
 static const char range_codes_pci1050_ai[] = { 0x00, 0x10, 0x30 };
 
-static const struct comedi_lrange range_pci1050_ao = { 1, {
-							  UNI_RANGE(10)
-							  }
-};
-
-static const char range_codes_pci1050_ao[] = { 0x00 };
-
 struct boardtype {
 	const char *name;
 	int device_id;
@@ -74,8 +67,6 @@ struct boardtype {
 	int do_bits;
 	const struct comedi_lrange *range_ai;
 	const char *range_codes_ai;
-	const struct comedi_lrange *range_ao;
-	const char *range_codes_ao;
 };
 
 static const struct boardtype boardtypes[] = {
@@ -92,8 +83,6 @@ static const struct boardtype boardtypes[] = {
 	.do_bits = 16,
 	.range_ai = &range_pci1050_ai,
 	.range_codes_ai = range_codes_pci1050_ai,
-	.range_ao = &range_pci1050_ao,
-	.range_codes_ao = range_codes_pci1050_ao,
 	},
 	/*  dummy entry corresponding to driver name */
 	{.name = DRV_NAME},
@@ -290,7 +279,7 @@ static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
 	s->subdev_flags = SDF_WRITABLE;
 	s->n_chan = thisboard->ao_chans;
 	s->maxdata = 0x0FFF;
-	s->range_table = thisboard->range_ao;
+	s->range_table = &range_unipolar10;
 	s->len_chanlist = 16;
 	s->insn_write = dyna_pci10xx_insn_write_ao;
 
-- 
1.7.11

