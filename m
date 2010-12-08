Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab0LHBBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:41 -0500
Received: from kroah.org ([198.145.64.141]:49045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab0LHBBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:38 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:35 2010
Message-Id: <20101208005735.686469871@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [143/289] [media] gspca - main: Fix a regression with the PS3 Eye webcam
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>

commit f43402fa55bf5e7e190c176343015122f694857c upstream.

When audio is present, some alternate settings were skipped.
This prevented some webcams to work, especially when bulk transfer was used.
This patch permits to use the last or only alternate setting.

Reported-by: Antonio Ospite <ospite@studenti.unina.it>
Tested-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/gspca.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -652,7 +652,7 @@ static struct usb_host_endpoint *get_ep(
 				   : USB_ENDPOINT_XFER_ISOC;
 	i = gspca_dev->alt;			/* previous alt setting */
 	if (gspca_dev->cam.reverse_alts) {
-		if (gspca_dev->audio)
+		if (gspca_dev->audio && i < gspca_dev->nbalt - 2)
 			i++;
 		while (++i < gspca_dev->nbalt) {
 			ep = alt_xfer(&intf->altsetting[i], xfer);
@@ -660,7 +660,7 @@ static struct usb_host_endpoint *get_ep(
 				break;
 		}
 	} else {
-		if (gspca_dev->audio)
+		if (gspca_dev->audio && i > 1)
 			i--;
 		while (--i >= 0) {
 			ep = alt_xfer(&intf->altsetting[i], xfer);


