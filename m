Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab0EEWra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:47:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64515 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab0EEWr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:47:27 -0400
Date: Wed, 5 May 2010 15:44:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] media: fix vivi build error
Message-Id: <20100505154411.609de129.randy.dunlap@oracle.com>
In-Reply-To: <20100505123409.ed5678a2.sfr@canb.auug.org.au>
References: <20100505123409.ed5678a2.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4BE1F578.00D7:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

vivi uses find_font(), which is only available when FONTS
is enabled, so make vivi depend on FONTS.

ERROR: "find_font" [drivers/media/video/vivi.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100505.orig/drivers/media/video/Kconfig
+++ linux-next-20100505/drivers/media/video/Kconfig
@@ -559,7 +559,7 @@ config VIDEO_DAVINCI_VPIF
 
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
+	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64 && FONTS
 	select FONT_8x16
 	select VIDEOBUF_VMALLOC
 	default n
