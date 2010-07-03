Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab0GCQEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:04:41 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab0GCQEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MojiuhdnIC8bMe55ZWaQlTPnii003rxIkuiIO6jY7B+pSTv0WkfiVxAPiJ0YTxk6hJ
         XVdOE77w1dNAZ7bRKBpAHGYJzF/zGWbj23ya0w4sfL2F2R8732VhywGME4oknIC0+Dqr
         TEBGQwh62rNPwGjyARVI9UshCjS8Io0jSys6I=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, Stefan Assmann <sassmann@redhat.com>,
       Andrew Patterson <andrew.patterson@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 16/19] drivers/pci: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:04:35 +0400
Message-Id: <1278173076-11949-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/pci/search.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 20d03f7..9d75dc8 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -169,7 +169,7 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
 {
 	struct pci_dev *dev = NULL;
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev) {
 		if (pci_domain_nr(dev->bus) == domain &&
 		    (dev->bus->number == bus && dev->devfn == devfn))
 			return dev;
-- 
1.7.0.4

