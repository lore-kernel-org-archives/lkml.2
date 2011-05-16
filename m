Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1EPMZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:25:03 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41645 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1EPMZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:25:01 -0400
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, Markus Grabner <grabner@icg.tugraz.at>,
        Kulikov Vasiliy <segooon@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/staging/line6/driver.c: Drop unneeded put functions.
Date: Mon, 16 May 2011 14:24:57 +0200
Message-Id: <1305548697-27591-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This seems to be the result of patches ab366c1a and 1027f476 crossing each
other.  Patch ab366c1a adds calls to usb_put_intf and usb_put_dev at the
end of the function line6_probe, in the error handling code, while patch
1027f476 moves the calls to the corresponding get function from the
beginning to the end of line6_probe, making the calls to put in the error
handling code unnecessary.

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/line6/driver.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index ea9209d..851b762 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -1094,8 +1094,6 @@ static int line6_probe(struct usb_interface *interface,
 err_destruct:
 	line6_destruct(interface);
 err_put:
-	usb_put_intf(interface);
-	usb_put_dev(usbdev);
 	return ret;
 }
 

