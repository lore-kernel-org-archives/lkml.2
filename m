Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0KKDSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 22:18:01 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64837 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab0KKDR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 22:17:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VoUKDdvkcIxzyAq/ssiPiOLBGh9hymyKT2fTa9tSltYieW82QVeknu7apamHL/VzTB
         1nIY3D7TFmFb2uXmBh0PyRIAK2SBbGhn/ZGmwXvINGPSDt7qEIAwWbhnKqoiaId1D53R
         rzaOeEzwo7o9J8oJz/WDN34Cj568QAdPt9d48=
Subject: [PATCH] Input: acecad - fix a memory leak in usb_acecad_probe
	error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane VOLTZ <svoltz@numericable.fr>,
        Edouard TISSERANT <edouard.tisserant@wanadoo.fr>,
        linux-input@vger.kernel.org
Content-Type: text/plain
Date: Thu, 11 Nov 2010 11:21:55 +0800
Message-Id: <1289445715.3183.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing usb_free_urb() in usb_acecad_probe() error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/tablet/acecad.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/input/tablet/acecad.c b/drivers/input/tablet/acecad.c
index aea9a93..d94f7e9 100644
--- a/drivers/input/tablet/acecad.c
+++ b/drivers/input/tablet/acecad.c
@@ -229,12 +229,13 @@ static int usb_acecad_probe(struct usb_interface *intf, const struct usb_device_
 
 	err = input_register_device(acecad->input);
 	if (err)
-		goto fail2;
+		goto fail3;
 
 	usb_set_intfdata(intf, acecad);
 
 	return 0;
 
+ fail3:	usb_free_urb(acecad->irq);
  fail2:	usb_free_coherent(dev, 8, acecad->data, acecad->data_dma);
  fail1: input_free_device(input_dev);
 	kfree(acecad);
-- 
1.7.2



