Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab0HGGg6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:36:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33198 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235Ab0HGGgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:36:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=p7mPsLFoNEDj4weJFM2ds9ZNrlfu82Y9mUcqNzO1ZGGcEuLGeiSbIOnGYF+ZBy72pq
         zGlgL4qZ10bTB55zan8FCG00M3dxAUHFzClO2YMG44UvctQNFfNqQIw94jqkRbTMbQ2H
         umAXTjPTUTqekpo/XKGeTMNB6aW6J6VH3rV6w=
Subject: [PATCH 06/14] staging: comedi (cb_pcimdas): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:36:45 -0400
Message-ID: <1281163005.7976.13.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index ced346a..16c322d 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -126,10 +126,8 @@ static const struct cb_pcimdas_board cb_pcimdas_boards[] = {
 /* This is used by modprobe to translate PCI IDs to drivers.  Should
  * only be used for PCI and ISA-PnP devices */
 static DEFINE_PCI_DEVICE_TABLE(cb_pcimdas_pci_table) = {
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0056, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0056) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, cb_pcimdas_pci_table);
-- 
1.7.0.4



