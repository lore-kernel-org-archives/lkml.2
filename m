Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0FPFe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:34:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52352 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab0FPFdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nIwop147Zn7KQoB9m53I49omkEUxMa9zs09jDOOmfqlcG44tkKyCb+F5diPKkr3KEa
         gYoJq3xpGr5bFA3OcJpvth25mr1juEL53W4NOYyBaBn3P0rdATl2OnVvm8V6CottCIdG
         EozPsKEssUUJ56oS29KeyMfmen7skEBX937hM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-scsi@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/5]pci:bus.c Fix variable 'retval' set but not used
Date: Tue, 15 Jun 2010 22:33:52 -0700
Message-Id: <1276666434-11227-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes the warning message I am seeing with gcc 4.6.0
  CC      drivers/pci/bus.o
drivers/pci/bus.c: In function 'pci_enable_bridges':
drivers/pci/bus.c:237:6: warning: variable 'retval' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/pci/bus.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 628ea20..84bdb48 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -234,12 +234,10 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 void pci_enable_bridges(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
-	int retval;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		if (dev->subordinate) {
 			if (!pci_is_enabled(dev)) {
-				retval = pci_enable_device(dev);
 				pci_set_master(dev);
 			}
 			pci_enable_bridges(dev->subordinate);
-- 
1.7.1.rc1.21.gf3bd6

