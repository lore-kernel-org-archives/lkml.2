Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab0DVUmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:42:36 -0400
Received: from kroah.org ([198.145.64.141]:37336 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab0DVT1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:54 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:10 2010
Message-Id: <20100422190910.503162013@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       Christian Lamparter <chunkeey@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [035/197] setup correct int pipe type in ar9170_usb_exec_cmd
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Valentin Longchamp <valentin.longchamp@epfl.ch>

commit 2d20c72c021d96f8b9230396c8e3782f204214ec upstream.

An int urb is constructed but we fill it in with a bulk pipe type.

Commit f661c6f8c67bd55e93348f160d590ff9edf08904 implemented a pipe type
check when CONFIG_USB_DEBUG is enabled. The check failed for all the ar9170
usb transfers and the driver could not configure the wifi dongle.

This went unnoticed until now because most people don't have
CONFIG_USB_DEBUG enabled.

Signed-off-by: Valentin Longchamp <valentin.longchamp@epfl.ch>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ar9170/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -414,7 +414,7 @@ static int ar9170_usb_exec_cmd(struct ar
 	spin_unlock_irqrestore(&aru->common.cmdlock, flags);
 
 	usb_fill_int_urb(urb, aru->udev,
-			 usb_sndbulkpipe(aru->udev, AR9170_EP_CMD),
+			 usb_sndintpipe(aru->udev, AR9170_EP_CMD),
 			 aru->common.cmdbuf, plen + 4,
 			 ar9170_usb_tx_urb_complete, NULL, 1);
 


