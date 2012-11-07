Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2KGMIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:08:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2KGMIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:08:43 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        hsweeten@visionengravers.com, ravishankar.km@greenturtles.in,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: jr3_pci.c: fix for coding style issue
Date: Wed,  7 Nov 2012 04:08:09 -0800
Message-Id: <1352290089-14477-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed few error and warning messages as reported by checkpatch.pl

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/comedi/drivers/jr3_pci.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 364541d..20fdb7b 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -360,7 +360,7 @@ static int read_idm_word(const u8 *data, size_t size, int *pos,
 	return result;
 }
 
-static int jr3_download_firmware(struct comedi_device *dev, const u8 * data,
+static int jr3_download_firmware(struct comedi_device *dev, const u8 *data,
 				 size_t size)
 {
 	/*
@@ -470,14 +470,13 @@ static struct poll_delay_t jr3_pci_poll_subdevice(struct comedi_subdevice *s)
 		struct jr3_channel __iomem *channel = p->channel;
 		int errors = get_u16(&channel->errors);
 
-		if (errors != p->errors) {
+		if (errors != p->errors)
 			p->errors = errors;
-		}
-		if (errors & (watch_dog | watch_dog2 | sensor_change)) {
+
+		if (errors & (watch_dog | watch_dog2 | sensor_change))
 			/*  Sensor communication lost, force poll mode */
 			p->state = state_jr3_poll;
 
-		}
 		switch (p->state) {
 		case state_jr3_poll: {
 				u16 model_no = get_u16(&channel->model_no);
-- 
1.7.9.5

