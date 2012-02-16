Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2BPV6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:58:17 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39639 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2BPV6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:58:16 -0500
From: Ben Collins <bcollins@ubuntu.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: UDLFB:  Make sure to get correct endian keys from vendor descriptor
Date: Thu, 16 Feb 2012 16:58:11 -0500
Message-Id: <09CD7791-DCBE-45BC-96D3-DFE60971D067@ubuntu.com>
Cc: Bernie Thompson <bernie@plugable.com>,
        libdlo <libdlo@lists.freedesktop.org>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1257)
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver was not using le16_to_cpu when reading keys from the vendor
descriptor, causing incorrect parsing. Mainly, sku_pixel_limit was not
being parsed on big-endian systems. This left udlfb most certainly
broken on low level chips as the driver allows modes that are too
high for the chip by default.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>

diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index a197731..0319593 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -1537,7 +1537,7 @@ static int dlfb_parse_vendor_descriptor(struct dlfb_data *dev,
 			u8 length;
 			u16 key;
 
-			key = *((u16 *) desc);
+			key = le16_to_cpu(*((u16 *) desc));
 			desc += sizeof(u16);
 			length = *desc;
 			desc++;

--
Bluecherry: http://www.bluecherrydvr.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

