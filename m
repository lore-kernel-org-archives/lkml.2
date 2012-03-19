Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161981Ab2CSFy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:54:56 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25414 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161893Ab2CSFtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:35 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 04/26] PCI: Update pci_resource_start to use pci_dev_resource_n()
Date: Sun, 18 Mar 2012 22:48:27 -0700
Message-Id: <1332136129-14010-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F66C8EC.0081,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of use resource[bar], to prepare for addon resource usages.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/pci.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index e3f9ae1..c7a2806 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1400,9 +1400,9 @@ static inline int pci_domain_nr(struct pci_bus *bus)
 
 /* these helpers provide future and backwards compatibility
  * for accessing popular PCI BAR info */
-#define pci_resource_start(dev, bar)	((dev)->resource[(bar)].start)
-#define pci_resource_end(dev, bar)	((dev)->resource[(bar)].end)
-#define pci_resource_flags(dev, bar)	((dev)->resource[(bar)].flags)
+#define pci_resource_start(dev, bar)	(pci_dev_resource_n(dev, (bar))->start)
+#define pci_resource_end(dev, bar)	(pci_dev_resource_n(dev, (bar))->end)
+#define pci_resource_flags(dev, bar)	(pci_dev_resource_n(dev, (bar))->flags)
 #define pci_resource_len(dev,bar) \
 	((pci_resource_start((dev), (bar)) == 0 &&	\
 	  pci_resource_end((dev), (bar)) ==		\
-- 
1.7.7

