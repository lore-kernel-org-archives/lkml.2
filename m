Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648Ab2HQCwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:52:43 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:35589 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab2HQCwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:52:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1345171960!7213242!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 27/35] staging: comedi: cb_pcimdda: remove ao_chans and ao_bits from boardinfo
Date: Thu, 16 Aug 2012 19:52:30 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161952.30362.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This board always has 6, 16-bit analog outputs. There is no need to carry
this information in the boardinfo. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 0e34603..82fb5f6 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -105,16 +105,12 @@ Configuration Options:
 struct cb_pcimdda_board {
 	const char *name;
 	unsigned short device_id;
-	int ao_chans;
-	int ao_bits;
 };
 
 static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
 	{
 	 .name = "cb_pcimdda06-16",
 	 .device_id = PCI_ID_PCIM_DDA06_16,
-	 .ao_chans = 6,
-	 .ao_bits = 16,
 	 }
 };
 
@@ -258,8 +254,8 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
-	s->n_chan = thisboard->ao_chans;
-	s->maxdata = (1 << thisboard->ao_bits) - 1;
+	s->n_chan = 6;
+	s->maxdata = 0xffff;
 	/* this is hard-coded here */
 	if (it->options[2])
 		s->range_table = &range_bipolar10;
-- 
1.7.11

