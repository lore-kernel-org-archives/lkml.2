Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0LAE2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 23:28:50 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37497 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab0LAE2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 23:28:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=BC+tLWjQnm6JzcjYYBpCxIm8untgahLHKBZBe+skGWj3WEJcglvmkkrqn6rp07XKOW
         6O4qLB9toAz9DnQP+i079IDhclTxfW+igz9jXRZQeE2mLpJHGye2uGHhbr8ftne9ygjd
         nBGlV5dR4XaLva/xKF/kUgqR3WKdXPAjVZnJY=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: whci-hcd: fix compiler warning
Date: Wed,  1 Dec 2010 13:28:41 +0900
Message-Id: <1291177721-17598-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate whci_hcd_id_table as '__used' to fix following warning:

  CC      drivers/usb/host/whci/hcd.o
drivers/usb/host/whci/hcd.c:359: warning: ‘whci_hcd_id_table’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/usb/host/whci/hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/whci/hcd.c b/drivers/usb/host/whci/hcd.c
index 72b6892..9546f6c 100644
--- a/drivers/usb/host/whci/hcd.c
+++ b/drivers/usb/host/whci/hcd.c
@@ -356,7 +356,7 @@ static void __exit whci_hc_driver_exit(void)
 module_exit(whci_hc_driver_exit);
 
 /* PCI device ID's that we handle (so it gets loaded) */
-static struct pci_device_id whci_hcd_id_table[] = {
+static struct pci_device_id __used whci_hcd_id_table[] = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_WIRELESS_WHCI, ~0) },
 	{ /* empty last entry */ }
 };
-- 
1.7.0.4

