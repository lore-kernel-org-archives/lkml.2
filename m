Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2JZAky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:40:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:52854 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2JZAGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ming Lei <ming.lei@canonical.com>, Oliver Neukum <oneukum@suse.de>
Subject: [ 15/42] USB: cdc-acm: fix pipe type of write endpoint
Date: Thu, 25 Oct 2012 17:05:23 -0700
Message-Id: <20121026000126.311887318@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000124.790781113@linuxfoundation.org>
References: <20121026000124.790781113@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit c5211187f7ff8e8dbff4ebf7c011ac4c0ffe319c upstream.

If the write endpoint is interrupt type, usb_sndintpipe() should
be passed to usb_fill_int_urb() instead of usb_sndbulkpipe().

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1234,7 +1234,7 @@ made_compressed_probe:
 
 		if (usb_endpoint_xfer_int(epwrite))
 			usb_fill_int_urb(snd->urb, usb_dev,
-				usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress),
+				usb_sndintpipe(usb_dev, epwrite->bEndpointAddress),
 				NULL, acm->writesize, acm_write_bulk, snd, epwrite->bInterval);
 		else
 			usb_fill_bulk_urb(snd->urb, usb_dev,


