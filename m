Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab1ERShS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:37:18 -0400
Received: from [138.40.68.24] ([138.40.68.24]:52696 "EHLO optosun2.city.ac.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933460Ab1ERShP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:37:15 -0400
From: "J. Ali Harlow" <ali@optosun7.city.ac.uk>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: devel@linuxdriverproject.org, Manuel Gebele <forensixs@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] comedi vmk80xx: Digitial I/O should have a maxdata of 1
Date: Wed, 18 May 2011 19:18:52 +0100
Message-Id: <1305742736-19434-2-git-send-email-ali@avrc.city.ac.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Digitial input and output sub-devices were reporting a maxdata of
0x1F and 0xFF respectively. They should both be 1.

Signed-off-by: J. Ali Harlow <ali@avrc.city.ac.uk>
---
 drivers/staging/comedi/drivers/vmk80xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 5d83bb6..01cfb76 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -1138,7 +1138,7 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
 	s->n_chan = dev->board.di_chans;
-	s->maxdata = (1 << dev->board.di_bits) - 1;
+	s->maxdata = 1;
 	s->insn_read = vmk80xx_di_rinsn;
 
 	/* Digital output subdevice */
@@ -1146,7 +1146,7 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITEABLE | SDF_GROUND;
 	s->n_chan = dev->board.do_chans;
-	s->maxdata = (1 << dev->board.do_bits) - 1;
+	s->maxdata = 1;
 	s->insn_write = vmk80xx_do_winsn;
 
 	if (dev->board.model == VMK8061_MODEL) {
-- 
1.7.4.1

