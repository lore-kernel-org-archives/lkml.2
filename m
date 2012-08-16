Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab2HPMyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:54:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60206 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab2HPMyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:54:44 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>
Subject: [PATCH] usb: hcd: use *resource_size_t* for specifying resource data
Date: Thu, 16 Aug 2012 18:24:19 +0530
Message-ID: <1345121659-24873-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the type of rsrc_start and rsrc_len from u64 to resource_size_t
so that it behaves well with resource API's like *resource_size()* on both
32bit and 64bit devices.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 include/linux/usb/hcd.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index c5fdb14..608050b 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -135,8 +135,8 @@ struct usb_hcd {
 
 	unsigned int		irq;		/* irq allocated */
 	void __iomem		*regs;		/* device memory/io */
-	u64			rsrc_start;	/* memory/io resource start */
-	u64			rsrc_len;	/* memory/io resource length */
+	resource_size_t		rsrc_start;	/* memory/io resource start */
+	resource_size_t		rsrc_len;	/* memory/io resource length */
 	unsigned		power_budget;	/* in mA, 0 = no limit */
 
 	/* bandwidth_mutex should be taken before adding or removing
-- 
1.7.9.5

