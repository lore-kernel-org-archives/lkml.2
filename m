Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1H2LKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:10:43 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:56667 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab1H2LKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:10:35 -0400
From: Felipe Balbi <balbi@ti.com>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] sound: usb: mixer: increase control transfer timeout
Date: Mon, 29 Aug 2011 14:10:26 +0300
Message-Id: <1314616226-15942-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

100ms might not be enough for slower devices. Increasing
timeout to 1000ms doesn't seem like overkill.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---

Not sure this information is valid on a commit log, but I
have a FPGA-platform which I use to test my USB controller
and when that's running on FS, this message fails because
control message times out before controller has the opportunity
to complete all three phases of the SETUP transaction.

 sound/usb/mixer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index cdd19d7..a3cbc98 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -296,7 +296,7 @@ static int get_ctl_value_v1(struct usb_mixer_elem_info *cval, int request, int v
 		if (snd_usb_ctl_msg(chip->dev, usb_rcvctrlpipe(chip->dev, 0), request,
 				    USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
 				    validx, snd_usb_ctrl_intf(chip) | (cval->id << 8),
-				    buf, val_len, 100) >= val_len) {
+				    buf, val_len, 1000) >= val_len) {
 			*value_ret = convert_signed_value(cval, snd_usb_combine_bytes(buf, val_len));
 			snd_usb_autosuspend(cval->mixer->chip);
 			return 0;
-- 
1.7.6.396.ge0613

