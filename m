Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1K1OMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:12:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50581 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1K1OMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:12:31 -0500
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: alsa-devel@alsa-project.org
Subject: [PATCH][sound/SOC] Do not register platform sound device unconditionally
Date: Mon, 28 Nov 2011 15:11:39 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201111281511.40633.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Registering a SOC device and also changing register unconditionally fails on
kernels which support more than one machine in one binary. Do it only if the
platform matches.

Signed-off-by: Juergen Beisert <jbe@pengutronix.de>

diff --git a/sound/soc/imx/mx27vis-aic32x4.c b/sound/soc/imx/mx27vis-aic32x4.c
index 054110b..c5cfb8a 100644
--- a/sound/soc/imx/mx27vis-aic32x4.c
+++ b/sound/soc/imx/mx27vis-aic32x4.c
@@ -96,6 +96,10 @@ static int __init mx27vis_aic32x4_init(void)
 {
 	int ret;
 
+	if (!machine_is_imx27_visstrim_m10())
+		/* return happy. We run on a totally different machine */
+		return 0;
+
 	mx27vis_aic32x4_snd_device = platform_device_alloc("soc-audio", -1);
 	if (!mx27vis_aic32x4_snd_device)
 		return -ENOMEM;

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
