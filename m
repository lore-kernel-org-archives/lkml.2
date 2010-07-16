Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965719Ab0GPO0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 10:26:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965676Ab0GPO0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 10:26:44 -0400
Date: Fri, 16 Jul 2010 17:20:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, vgoyal@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, seto.hidetoshi@jp.fujitsu.com,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH repost] pci: fix compilation when CONFIG_PCI_MSI=n
Message-ID: <20100716142050.GA4970@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vers/pci/pci.c:2277: error: redefinition of ‘pci_msi_off’
include/linux/pci.h:786: note: previous definition of ‘pci_msi_off’ was here

No need for ifdef: we must disable the capability at startup even if the
current kernel does not support MSI, otherwise the device won't work.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Looks like I didn't tag this old patch of mine clearly enough
so it's still not fixed in -rc5.
It's late in the cycle, but the patch is trivial
and it's a build fix, so ... please consider for 2.6.35.

 include/linux/pci.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 31d8a12..7cb0084 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -780,11 +780,7 @@ int __must_check pci_set_mwi(struct pci_dev *dev);
 int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
-#ifdef CONFIG_PCI_MSI
 void pci_msi_off(struct pci_dev *dev);
-#else
-static inline void pci_msi_off(struct pci_dev *dev) {}
-#endif
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
 int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
 int pcix_get_max_mmrbc(struct pci_dev *dev);
-- 
1.7.2.rc0.14.g41c1c
