Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab2GFR2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:28:36 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:59768 "HELO
	mailout-us.mail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755830Ab2GFR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:28:33 -0400
X-Authenticated: #53258690
X-Provags-ID: V01U2FsdGVkX19FinRgWNlF5hwxWXkCVxFcI98a7RxmXsiIxxUH1a
	tgOpS5fheXd3vD
Date: Fri, 6 Jul 2012 12:28:17 -0500
From: Bob Ross <pigiron@gmx.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jan Steinhoff <mail@jan-steinhoff.de>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] synaptics_usb: Remove TrackPoint name trailing whitespace
Message-ID: <20120706122817.4ff2cdbf@atom.pigiron.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The USB TrackPoint name string contains a space at the trailing end that
can cause confusion/difficulty when creating udev rules. Example:

 "Synaptics Inc. Composite TouchPad / TrackPoint (Stick) "

This patch removes the trailing space.

Signed-off-by: Bob Ross <pigiron@gmx.com>
---
This patch was based from the "torvalds" git tree.

 drivers/input/mouse/synaptics_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/synaptics_usb.c b/drivers/input/mouse/synaptics_usb.c
index 3c5eaaa..64cf34e 100644
--- a/drivers/input/mouse/synaptics_usb.c
+++ b/drivers/input/mouse/synaptics_usb.c
@@ -364,7 +364,7 @@ static int synusb_probe(struct usb_interface *intf,
 			 le16_to_cpu(udev->descriptor.idProduct));
 
 	if (synusb->flags & SYNUSB_STICK)
-		strlcat(synusb->name, " (Stick) ", sizeof(synusb->name));
+		strlcat(synusb->name, " (Stick)", sizeof(synusb->name));
 
 	usb_make_path(udev, synusb->phys, sizeof(synusb->phys));
 	strlcat(synusb->phys, "/input0", sizeof(synusb->phys));
-- 
1.7.11

