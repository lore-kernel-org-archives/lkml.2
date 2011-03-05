Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509Ab1CEBAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:41 -0500
Received: from kroah.org ([198.145.64.141]:50379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760482Ab1CEBAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:39 2011
Message-Id: <20110305005639.287288989@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oliver Neukum <oneukum@suse.de>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [48/73] Bluetooth: fix crash with quirky dongles doing sound
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 8efdd0cdc54f3bb5db464b3baf88f7441f54da47 upstream.

Quirky dongles sometimes do not use the iso interface which
causes a crash with runtime PM

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/btusb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -829,7 +829,7 @@ static void btusb_work(struct work_struc
 
 	if (hdev->conn_hash.sco_num > 0) {
 		if (!test_bit(BTUSB_DID_ISO_RESUME, &data->flags)) {
-			err = usb_autopm_get_interface(data->isoc);
+			err = usb_autopm_get_interface(data->isoc ? data->isoc : data->intf);
 			if (err < 0) {
 				clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
 				usb_kill_anchored_urbs(&data->isoc_anchor);
@@ -858,7 +858,7 @@ static void btusb_work(struct work_struc
 
 		__set_isoc_interface(hdev, 0);
 		if (test_and_clear_bit(BTUSB_DID_ISO_RESUME, &data->flags))
-			usb_autopm_put_interface(data->isoc);
+			usb_autopm_put_interface(data->isoc ? data->isoc : data->intf);
 	}
 }
 


