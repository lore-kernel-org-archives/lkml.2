Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047Ab2JXOoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:44:46 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43746 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934820Ab2JXOop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:44:45 -0400
Date: Wed, 24 Oct 2012 16:44:35 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Randy Dunlap <rdunlap@xenotime.net>, Felipe Balbi <balbi@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: [PATCH] usb/gadget: let file storage gadget select libcomposite
Message-ID: <20121024144435.GF4368@breakpoint.cc>
References: <20121018144614.b61961cfae2274d52d340882@canb.auug.org.au>
 <50809624.30601@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50809624.30601@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Wed, 24 Oct 2012 16:40:10 +0200

found by randconfig, Randy Dunlap and Stephen Rothwell:

|drivers/built-in.o: In function `fsg_setup':
|file_storage.c:(.text+0x24db7c): undefined reference to `usb_gadget_config_buf'
|file_storage.c:(.text+0x24db98): undefined reference to `usb_gadget_get_string'
|drivers/built-in.o: In function `fsg_bind':
|file_storage.c:(.init.text+0xee42): undefined reference to `usb_ep_autoconfig_reset'
|file_storage.c:(.init.text+0xee51): undefined reference to `usb_ep_autoconfig'
|file_storage.c:(.init.text+0xee73): undefined reference to `usb_ep_autoconfig'
|file_storage.c:(.init.text+0xee9e): undefined reference to `usb_ep_autoconfig'

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
for v3.7 please.

 drivers/usb/gadget/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index bbcec83..66bc3ab 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -737,6 +737,7 @@ config USB_FUNCTIONFS_GENERIC
 
 config USB_FILE_STORAGE
 	tristate "File-backed Storage Gadget (DEPRECATED)"
+	select USB_LIBCOMPOSITE
 	depends on BLOCK
 	help
 	  The File-backed Storage Gadget acts as a USB Mass Storage
-- 
1.7.10.4

