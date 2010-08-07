Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab0HGGde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:33:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53765 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0HGGdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=mG0ykZU+ldPrrC9ECbzpzxOf98AGwJTxU4VKf1FgWf9drRi0LGlfW810utaq0XcI2r
         LYuxobI7D/IpBVY9/WT6Ape3VAVTmqk2L/K2rEjRZdjAo3HCUh2GEvBspej3nV6mKkOE
         pAIqWno2SlgCHfQfyeVvfyx5I8jP8+gn+uKiQ=
Subject: [PATCH 03/14] staging: comedi (cb_pcidio): user PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:33:26 -0400
Message-ID: <1281162806.7976.9.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidio.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index c1693c9..79477a5 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -91,11 +91,10 @@ static const struct pcidio_board pcidio_boards[] = {
 /* Please add your PCI vendor ID to comedidev.h, and it will be forwarded
  * upstream. */
 static DEFINE_PCI_DEVICE_TABLE(pcidio_pci_table) = {
-	{
-	PCI_VENDOR_ID_CB, 0x0028, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x0014, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x000b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0028) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0014) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x000b) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, pcidio_pci_table);
-- 
1.7.0.4






