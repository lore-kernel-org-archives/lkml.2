Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993471Ab2K3T3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:29:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:58175 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031634Ab2K3S4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 04/56] ALSA: snd-usb-caiaq: initialize card pointer
Date: Fri, 30 Nov 2012 10:54:56 -0800
Message-Id: <20121130185118.780723765@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit da185443c12f5ef7416af50293833a5654854186 upstream.

Fixes the following warning:

  CC [M]  sound/usb/caiaq/device.o
sound/usb/caiaq/device.c: In function ‘snd_probe’:
sound/usb/caiaq/device.c:500:16: warning: ‘card’ may be used
uninitialized in this function [-Wmaybe-uninitialized]

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/caiaq/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -485,7 +485,7 @@ static int __devinit snd_probe(struct us
 		     const struct usb_device_id *id)
 {
 	int ret;
-	struct snd_card *card;
+	struct snd_card *card = NULL;
 	struct usb_device *device = interface_to_usbdev(intf);
 
 	ret = create_card(device, intf, &card);


