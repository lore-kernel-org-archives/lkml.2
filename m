Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab2DXXAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:00:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416Ab2DXWez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:34:55 -0400
Message-Id: <20120424223243.713250534@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>
Subject: [ 20/62] uwb: fix error handling
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 5bd7b419ef2eb4989b207753e088c3437159618a upstream.

Fatal errors such as a device disconnect must not trigger
error handling. The error returns must be checked.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/uwb/hwa-rc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/uwb/hwa-rc.c
+++ b/drivers/uwb/hwa-rc.c
@@ -645,7 +645,8 @@ void hwarc_neep_cb(struct urb *urb)
 		dev_err(dev, "NEEP: URB error %d\n", urb->status);
 	}
 	result = usb_submit_urb(urb, GFP_ATOMIC);
-	if (result < 0) {
+	if (result < 0 && result != -ENODEV && result != -EPERM) {
+		/* ignoring unrecoverable errors */
 		dev_err(dev, "NEEP: Can't resubmit URB (%d) resetting device\n",
 			result);
 		goto error;


