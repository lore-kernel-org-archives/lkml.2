Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047Ab2CMAYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:48464 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759019Ab2CMAYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 141/196] Bluetooth: Add support Bluetooth controller of MacbookPro 6,2
Date: Mon, 12 Mar 2012 20:20:54 -0400
Message-Id: <1331598109-31424-96-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9c047157a20521cd525527947b13b950d168d2e6 upstream.

Bluetooth controller of MacbookPro 6,2 does not work.
Because Device Class of these controllers was set 255 (Vendor Sepecific Class).

T:  Bus=01 Lev=03 Prnt=03 Port=02 Cnt=03 Dev#=  8 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=05ac ProdID=8218 Rev=00.22
S:  Manufacturer=Apple Inc.
S:  Product=Bluetooth USB Host Controller
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c9e2dc8..f55332d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -65,6 +65,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Apple MacBookPro8,2 */
 	{ USB_DEVICE(0x05ac, 0x821a) },
 
+	/* Apple MacBookPro6,2 */
+	{ USB_DEVICE(0x05ac, 0x8218) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 
-- 
1.7.9.3

