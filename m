Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab2KZRlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:41:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542Ab2KZRKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:31 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 170/270] USB: cdc-acm: fix pipe type of write endpoint
Date: Mon, 26 Nov 2012 14:57:40 -0200
Message-Id: <1353949160-26803-171-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit c5211187f7ff8e8dbff4ebf7c011ac4c0ffe319c upstream.

If the write endpoint is interrupt type, usb_sndintpipe() should
be passed to usb_fill_int_urb() instead of usb_sndbulkpipe().

Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 2e29044..f4593ee 100644
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
-- 
1.7.9.5

