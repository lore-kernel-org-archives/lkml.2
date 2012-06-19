Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2FSXUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:20:47 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:27713 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2FSXUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:20:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1340148028!7218327!8
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/5] staging: comedi: remove CONFIG_COMEDI_PCI define
Date: Tue, 19 Jun 2012 16:20:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206191620.24205.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_COMEDI_PCI is not actually a Kconfig option. It is defined
in the comedidev.h header based on another Kconfig option being
enabled.

It is only referenced in the skel driver to conditionally compile
in the PCI support code. Use the CONFIG_COMEDI_PCI_DRIVERS Kconfig
option instead and remove the define.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedidev.h    | 7 -------
 drivers/staging/comedi/drivers/skel.c | 2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index c93c87d..18f8f4c 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -507,11 +507,4 @@ int comedi_usb_auto_config(struct usb_interface *intf,
 			   struct comedi_driver *driver);
 void comedi_usb_auto_unconfig(struct usb_interface *intf);
 
-#ifdef CONFIG_COMEDI_PCI_DRIVERS
-#define CONFIG_COMEDI_PCI
-#endif
-#ifdef CONFIG_COMEDI_PCI_DRIVERS_MODULE
-#define CONFIG_COMEDI_PCI
-#endif
-
 #endif /* _COMEDIDEV_H */
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 92d44c1..a9fed4b 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -614,7 +614,7 @@ static int skel_dio_insn_config(struct comedi_device *dev,
 	return insn->n;
 }
 
-#ifdef CONFIG_COMEDI_PCI
+#ifdef CONFIG_COMEDI_PCI_DRIVERS
 static int __devinit driver_skel_pci_probe(struct pci_dev *dev,
 					   const struct pci_device_id *ent)
 {
-- 
1.7.11

