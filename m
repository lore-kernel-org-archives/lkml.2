Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742Ab2JJXE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:04:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33358 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757656Ab2JJXDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:50 -0400
X-Sasl-enc: YJ5Oa51xSKirA82DxOXastSZXqgGYqDq9z/T7WWlv7cF 1349910229
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 071/122] ALSA: usb - disable broken hw volume for Tenx TP6911
Date: Thu, 11 Oct 2012 07:53:57 +0900
Message-Id: <20121010225350.899754569@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit c10514394ef9e8de93a4ad8c8904d71dcd82c122 upstream.

While going through Ubuntu bugs, I discovered this patch being
posted and a confirmation that the patch works as expected.

Finding out how the hw volume really works would be preferrable
to just disabling the broken one, but this would be better than
nothing.

Credit: sndfnsdfin (qawsnews)
BugLink: https://bugs.launchpad.net/bugs/559939
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1267,6 +1267,13 @@ static int parse_audio_feature_unit(stru
 		/* disable non-functional volume control */
 		master_bits &= ~UAC_CONTROL_BIT(UAC_FU_VOLUME);
 		break;
+	case USB_ID(0x1130, 0xf211):
+		snd_printk(KERN_INFO
+			   "usbmixer: volume control quirk for Tenx TP6911 Audio Headset\n");
+		/* disable non-functional volume control */
+		channels = 0;
+		break;
+
 	}
 	if (channels > 0)
 		first_ch_bits = snd_usb_combine_bytes(bmaControls + csize, csize);


