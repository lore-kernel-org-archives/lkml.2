Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab0GCQEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:04:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab0GCQEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dyUrDCR+KndMperiS7DJBEg/XvdGIGxmCMhiYTbMEt+No/vdjEY42FzpPoGOS/Ydvf
         nce6cLKI41QCfnVO15GLxIXTv5kjIPk2xDvndItKiWlUXWxvYyyf6FclXtQO1e8Mm76u
         TUqKowIe+UahkzcMAUAMTy+PHnmGYoxJb9ONQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 19/19] drivers/usb/core: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:04:47 +0400
Message-Id: <1278173088-12051-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/usb/core/hcd-pci.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 7e2d527..c1f0bba 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -66,10 +66,7 @@ static void companion_common(struct pci_dev *pdev, struct usb_hcd *hcd,
 	 * vice versa.
 	 */
 	companion = NULL;
-	for (;;) {
-		companion = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, companion);
-		if (!companion)
-			break;
+	for_each_pci_dev(companion) {
 		if (companion->bus != pdev->bus ||
 				PCI_SLOT(companion->devfn) != slot)
 			continue;
-- 
1.7.0.4

