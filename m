Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373Ab0HGGk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:40:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55791 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512Ab0HGGk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=wbBeuOJL44ntJ4BIXTyToDhQ7aunIQ4pH+eXZfUorSb7M6+gxH1nn6cmVCFOhj5hBK
         /uYaS/+bACmTWQbckaEvH+Ye0J6DmIMbPy1j5Z0lOf3GUpYaSiSQnYfh5L2G09Hod3Jg
         MG3YKy/Y4n7DQqyjeKSzcjLEsmopfoiccrlD4=
Subject: [PATCH 10/14] staging: comedi (skel): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:40:20 -0400
Message-ID: <1281163220.7976.17.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/skel.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 0b9ecb1..ed69008 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -116,10 +116,9 @@ static const struct skel_board skel_boards[] = {
  * upstream. */
 #define PCI_VENDOR_ID_SKEL 0xdafe
 static DEFINE_PCI_DEVICE_TABLE(skel_pci_table) = {
-	{
-	PCI_VENDOR_ID_SKEL, 0x0100, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_SKEL, 0x0200, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_SKEL, 0x0100) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_SKEL, 0x0200) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, skel_pci_table);
-- 
1.7.0.4



