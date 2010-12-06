Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0LFQDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:03:38 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:58917 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LFQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:03:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=gqw3RYDVdg7oEaXx3wvF01pknqJ5C+9pRy41iMh9bu+PytK1Y4xOUZDkx4qm6Xb567
         AKnf52VY8Qf6FUXSw9Lp3cyW1p/EozpSrgMdUutYsFusRQj+NsbGiz1lz1x8yZPDz4g7
         lDTGA1uP4UWT89OvsaXVrGUnKQJfkXSKOO9QE=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] USB: whci-hcd: fix compiler warning
Date: Tue,  7 Dec 2010 01:03:32 +0900
Message-Id: <1291651412-8467-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20101206155625.GC23214@kroah.com>
References: <20101206155625.GC23214@kroah.com>
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

