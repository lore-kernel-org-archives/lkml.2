Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1HZSGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:06:13 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38382 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752899Ab1HZSGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:06:10 -0400
Date: Fri, 26 Aug 2011 11:06:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Edwin Rong <edwin_rong@realsil.com.cn>, gregkh@suse.de,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
Subject: [PATCH -next] staging: fix rts5139 depends & build
Message-Id: <20110826110608.5286a8d7.rdunlap@xenotime.net>
In-Reply-To: <20110826150000.302334d0b86c17cd9b89b590@canb.auug.org.au>
References: <20110826150000.302334d0b86c17cd9b89b590@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

RTS5139 should depend on USB, not USB_SUPPORT, to fix build
errors.
USB_SUPPORT can be enabled for gadget-only support
or when PCI is not enabled.

ERROR: "usb_reset_endpoint" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_kill_urb" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_deregister_dev" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_unlink_urb" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_deregister" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_register_dev" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_free_coherent" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_submit_urb" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_sg_cancel" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_find_interface" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_sg_init" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_register_driver" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_alloc_coherent" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_free_urb" [drivers/staging/rts5139/rts5139.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/staging/rts5139/rts5139.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Edwin Rong <edwin_rong@realsil.com.cn>
---
 drivers/staging/rts5139/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110826.orig/drivers/staging/rts5139/Kconfig
+++ linux-next-20110826/drivers/staging/rts5139/Kconfig
@@ -1,6 +1,6 @@
 config RTS5139
 	tristate "Realtek RTS5139 USB card reader support"
-	depends on USB_SUPPORT && SCSI
+	depends on USB && SCSI
 	help
 	  Say Y here to include driver code to support the Realtek
 	  RTS5139 USB card readers.
