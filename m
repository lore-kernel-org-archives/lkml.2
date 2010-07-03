Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0GCQGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:06:51 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab0GCQEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Q0g2lN/WLSPGO/j46thJqbmr3DfUbj5IgwmeHWp/NBlOOOpjRKoNCW4WiPZm7Bp01q
         FaBYEcWr9RhvbI2lgwBskGgYyhSs++nWqTCfdgKNEJvezupXqFC5tNg1VCBu1CdSHVBU
         E4v1jRfWZnO2yno9BimbiWYiHebDZ+tcyIMdg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Doug Thompson <dougthompson@xmission.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       David Teigland <teigland@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Hans J. Koch" <hjk@linutronix.de>,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 09/19] drivers/edac: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:04:07 +0400
Message-Id: <1278173048-11711-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/edac/edac_pci_sysfs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index c39697d..dd28a82 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -653,9 +653,8 @@ static inline void edac_pci_dev_parity_iterator(pci_parity_check_fn_t fn)
 	 * and while we are looking at it have its reference count
 	 * bumped until we are done with it
 	 */
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev)
 		fn(dev);
-	}
 }
 
 /*
-- 
1.7.0.4

