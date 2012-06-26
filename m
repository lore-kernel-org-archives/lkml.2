Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab2FZAKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:10:39 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:26401 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab2FZAKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:10:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1340669434!6903279!7
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/33] staging: comedi: cb_das16_cs: fix analog output subdevice init
Date: Mon, 25 Jun 2012 17:10:30 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251710.30623.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The analog output subdevice is only available on the -AO version
of the DAS16/16 device and the number of channels is provided in
the boardinfo. Make sure the subdevice is marked as unused for
devices that do not support the analog out.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index f3d5ca0..acee550 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -509,6 +509,8 @@ static int das16cs_attach(struct comedi_device *dev,
 		s->range_table = &range_bipolar10;
 		s->insn_write = &das16cs_ao_winsn;
 		s->insn_read = &das16cs_ao_rinsn;
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
 	}
 
 	s = dev->subdevices + 2;
-- 
1.7.11

