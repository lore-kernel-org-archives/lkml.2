Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab1DYACt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 20:02:49 -0400
Received: from kroah.org ([198.145.64.141]:41639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934Ab1DYACl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 20:02:41 -0400
Date: Sun, 24 Apr 2011 16:59:30 -0700
From: Greg KH <greg@kroah.com>
To: netdev@vger.kernel.org
Cc: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Petter Selasky <hselasky@c2i.net>
Subject: [PATCH] cdc_ncm: fix short packet issue on some devices
Message-ID: <20110424235930.GA11109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Petter Selasky <hselasky@c2i.net>

The default maximum transmit length for NCM USB frames should be so
that a short packet happens at the end if the device supports a length
greater than the defined maximum. This is achieved by adding 4 bytes
to the maximum length so that the existing logic can fit a short
packet there.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/usb/cdc_ncm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 967371f..1033ef6 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -54,13 +54,13 @@
 #include <linux/usb/usbnet.h>
 #include <linux/usb/cdc.h>
 
-#define	DRIVER_VERSION				"7-Feb-2011"
+#define	DRIVER_VERSION				"23-Apr-2011"
 
 /* CDC NCM subclass 3.2.1 */
 #define USB_CDC_NCM_NDP16_LENGTH_MIN		0x10
 
 /* Maximum NTB length */
-#define	CDC_NCM_NTB_MAX_SIZE_TX			16384	/* bytes */
+#define	CDC_NCM_NTB_MAX_SIZE_TX			(16384 + 4) /* bytes, must be short terminated */
 #define	CDC_NCM_NTB_MAX_SIZE_RX			16384	/* bytes */
 
 /* Minimum value for MaxDatagramSize, ch. 6.2.9 */
-- 
1.7.1.1

