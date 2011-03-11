Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab1CKAue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:50:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:49299 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1CKAuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:50:32 -0500
Date: Thu, 10 Mar 2011 16:48:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2 -next] usb-storage: ene_ub6250 depends on USB_STORAGE
Message-Id: <20110310164836.1a39509c.randy.dunlap@oracle.com>
In-Reply-To: <20110310180934.95f4f607.sfr@canb.auug.org.au>
References: <20110310180934.95f4f607.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D7971D3.0054,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix ene_ub6250 build: it uses usb_storage driver interfaces, so it
should depend on USB_STORAGE.

ene_ub6250.c:(.text+0x14ff19): undefined reference to `usb_stor_reset_resume'
ene_ub6250.c:(.text+0x14ffb1): undefined reference to `usb_stor_bulk_transfer_buf'
ene_ub6250.c:(.text+0x14ffdd): undefined reference to `usb_stor_bulk_srb'
ene_ub6250.c:(.text+0x14fff1): undefined reference to `usb_stor_bulk_transfer_sg'
ene_ub6250.c:(.text+0x1503dd): undefined reference to `usb_stor_set_xfer_buf'
ene_ub6250.c:(.text+0x15048e): undefined reference to `usb_stor_access_xfer_buf'
ene_ub6250.c:(.text+0x150723): undefined reference to `usb_stor_probe1'
ene_ub6250.c:(.text+0x150795): undefined reference to `usb_stor_probe2'
ene_ub6250.c:(.text+0x1507af): undefined reference to `usb_stor_disconnect'
drivers/built-in.o:(.data+0x10224): undefined reference to `usb_stor_suspend'
drivers/built-in.o:(.data+0x10230): undefined reference to `usb_stor_pre_reset'
drivers/built-in.o:(.data+0x10234): undefined reference to `usb_stor_post_reset'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/storage/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110310.orig/drivers/usb/storage/Kconfig
+++ linux-next-20110310/drivers/usb/storage/Kconfig
@@ -212,6 +212,7 @@ config USB_LIBUSUAL
 config USB_STORAGE_ENE_UB6250
 	tristate "USB ENE card reader support"
 	depends on USB && SCSI
+	depends on USB_STORAGE
 	---help---
 	  Say Y here if you wish to control a ENE SD Card reader.
 	  To use SM/MS card, please build driver/staging/keucr/keucr.ko
