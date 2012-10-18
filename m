Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2JROq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:46:26 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55140 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab2JROqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:46:24 -0400
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 22:46:23 +0800
Message-ID: <CAPgLHd93+h76d2ABQCAaeM2PEuVQdBSTcuGAk_PG63AjCP0D6Q@mail.gmail.com>
Subject: [PATCH] ALSA: snd-usb: remove unused variable in init_pitch_v2()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: perex@perex.cz, tiwai@suse.de
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable ep is initialized but never used
otherwise, so remove the unused variable.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/usb/pcm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 55e19e1..f77b87a 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -171,11 +171,8 @@ static int init_pitch_v2(struct snd_usb_audio *chip, int iface,
 {
 	struct usb_device *dev = chip->dev;
 	unsigned char data[1];
-	unsigned int ep;
 	int err;
 
-	ep = get_endpoint(alts, 0)->bEndpointAddress;
-
 	data[0] = 1;
 	if ((err = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), UAC2_CS_CUR,
 				   USB_TYPE_CLASS | USB_RECIP_ENDPOINT | USB_DIR_OUT,

