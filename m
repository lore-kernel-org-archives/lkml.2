Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab0HLANN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:13:13 -0400
Received: from kroah.org ([198.145.64.141]:47898 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933195Ab0HLAIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:42 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:16 2010
Message-Id: <20100812000616.821091984@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anand Gadiyar <gadiyar@ti.com>, Felipe Balbi <felipe.balbi@nokia.com>,
        Ajay Kumar Gupta <ajay.gupta@ti.com>
Subject: [45/67] USB: musb: use correct register widths in register dumps
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anand Gadiyar <gadiyar@ti.com>

commit 0936fb5e92a90476959447ad8ae5d780afbbd930 upstream.

DMA_ADDR and DMA_COUNT are 32-bit registers, not 16-bit.

Marking them as 16-bit in the table causes only the lower
16-bits to be dumped and this is misleading.

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Acked-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_debugfs.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/usb/musb/musb_debugfs.c
+++ b/drivers/usb/musb/musb_debugfs.c
@@ -92,29 +92,29 @@ static const struct musb_register_map mu
 	{ "LS_EOF1",		0x7E,	8 },
 	{ "SOFT_RST",		0x7F,	8 },
 	{ "DMA_CNTLch0",	0x204,	16 },
-	{ "DMA_ADDRch0",	0x208,	16 },
-	{ "DMA_COUNTch0",	0x20C,	16 },
+	{ "DMA_ADDRch0",	0x208,	32 },
+	{ "DMA_COUNTch0",	0x20C,	32 },
 	{ "DMA_CNTLch1",	0x214,	16 },
-	{ "DMA_ADDRch1",	0x218,	16 },
-	{ "DMA_COUNTch1",	0x21C,	16 },
+	{ "DMA_ADDRch1",	0x218,	32 },
+	{ "DMA_COUNTch1",	0x21C,	32 },
 	{ "DMA_CNTLch2",	0x224,	16 },
-	{ "DMA_ADDRch2",	0x228,	16 },
-	{ "DMA_COUNTch2",	0x22C,	16 },
+	{ "DMA_ADDRch2",	0x228,	32 },
+	{ "DMA_COUNTch2",	0x22C,	32 },
 	{ "DMA_CNTLch3",	0x234,	16 },
-	{ "DMA_ADDRch3",	0x238,	16 },
-	{ "DMA_COUNTch3",	0x23C,	16 },
+	{ "DMA_ADDRch3",	0x238,	32 },
+	{ "DMA_COUNTch3",	0x23C,	32 },
 	{ "DMA_CNTLch4",	0x244,	16 },
-	{ "DMA_ADDRch4",	0x248,	16 },
-	{ "DMA_COUNTch4",	0x24C,	16 },
+	{ "DMA_ADDRch4",	0x248,	32 },
+	{ "DMA_COUNTch4",	0x24C,	32 },
 	{ "DMA_CNTLch5",	0x254,	16 },
-	{ "DMA_ADDRch5",	0x258,	16 },
-	{ "DMA_COUNTch5",	0x25C,	16 },
+	{ "DMA_ADDRch5",	0x258,	32 },
+	{ "DMA_COUNTch5",	0x25C,	32 },
 	{ "DMA_CNTLch6",	0x264,	16 },
-	{ "DMA_ADDRch6",	0x268,	16 },
-	{ "DMA_COUNTch6",	0x26C,	16 },
+	{ "DMA_ADDRch6",	0x268,	32 },
+	{ "DMA_COUNTch6",	0x26C,	32 },
 	{ "DMA_CNTLch7",	0x274,	16 },
-	{ "DMA_ADDRch7",	0x278,	16 },
-	{ "DMA_COUNTch7",	0x27C,	16 },
+	{ "DMA_ADDRch7",	0x278,	32 },
+	{ "DMA_COUNTch7",	0x27C,	32 },
 	{  }	/* Terminating Entry */
 };
 


