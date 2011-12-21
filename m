Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1LUTcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:32:14 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:46541 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753402Ab1LUTcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:32:11 -0500
Message-ID: <4EF2424D.4020200@xenotime.net>
Date: Wed, 21 Dec 2011 12:32:13 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] usb: fix renesas mod_gadget printk format warning
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
In-Reply-To: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning:

drivers/usb/renesas_usbhs/mod_gadget.c:188:3: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---

Also applies to mainline.

 drivers/usb/renesas_usbhs/mod_gadget.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20111221.orig/drivers/usb/renesas_usbhs/mod_gadget.c
+++ linux-next-20111221/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -185,7 +185,8 @@ static int usbhsg_dma_map(struct device
 	}
 
 	if (dma_mapping_error(dev, pkt->dma)) {
-		dev_err(dev, "dma mapping error %x\n", pkt->dma);
+		dev_err(dev, "dma mapping error %llx\n",
+				(unsigned long long)pkt->dma);
 		return -EIO;
 	}
 
