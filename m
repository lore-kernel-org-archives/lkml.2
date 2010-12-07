Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0LGPcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:32:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51392 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab0LGPb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:31:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=Awzlpu694slec0JI+hRNoXFkpt6F6pPZxvoestx1Ytxz7fG0b56YYdpR/N3XmzuL8X
         pTEnYETRUqGE7qz7ZR68hWFC0cNeRMV12YMimAJdl8DYsRHjutwCo0h/ZG/LguHRhbEY
         2wH/38ocnTZAMTc2yhnfHeEbk9lvATUF9AJ1Q=
From: Namhyung Kim <namhyung@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [SCSI] initio: fix compiler warning on i91u_pci_devices
Date: Wed,  8 Dec 2010 00:31:36 +0900
Message-Id: <1291735896-14541-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate i91u_pci_devices as '__used' to fix following warning:

  CC      drivers/scsi/initio.o
drivers/scsi/initio.c:131: warning: ‘i91u_pci_devices’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/scsi/initio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 9627d06..01c54cf 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -128,7 +128,7 @@ static int setup_debug = 0;
 static void i91uSCBPost(u8 * pHcb, u8 * pScb);
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id i91u_pci_devices[] = {
+static struct pci_device_id i91u_pci_devices[] __used = {
 	{ PCI_VENDOR_ID_INIT,  I950_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_INIT,  I940_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_INIT,  I935_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-- 
1.7.0.4

