Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0FOAEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 20:04:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48681 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab0FOAEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 20:04:30 -0400
Date: Mon, 14 Jun 2010 17:03:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-media@vger.kernel.org
Subject: [PATCH -next] vivi: fix depends again
Message-Id: <20100614170319.7647ab62.randy.dunlap@oracle.com>
In-Reply-To: <20100614123056.64aad41b.sfr@canb.auug.org.au>
References: <20100614123056.64aad41b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090203.4C16C386.018B:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

My previous patch to depend on FONTS was not sufficient since
FONTS is boolean.  VIDEO_VIVI needs to depend on a tristate so that
it won't be enabled as =y when framebuffer is built as modular, so
modify it to depend on the same symbols that FONTS depends on, which
are FRAMEBUFFER_CONSOLE || STI_CONSOLE.

Fixes this build error when VIDEO_VIVI=y and FRAMEBUFFER_CONSOLE=m:
vivi.c:(.init.text+0x7205): undefined reference to `find_font'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20100614.orig/drivers/media/video/Kconfig
+++ linux-next-20100614/drivers/media/video/Kconfig
@@ -559,7 +559,8 @@ config VIDEO_DAVINCI_VPIF
 
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64 && FONTS
+	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
+	depends on (FRAMEBUFFER_CONSOLE || STI_CONSOLE) && FONTS
 	select FONT_8x16
 	select VIDEOBUF_VMALLOC
 	default n
