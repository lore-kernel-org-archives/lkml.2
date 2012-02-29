Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965833Ab2B2XK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:10:56 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:26587 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab2B2XJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:09:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 20/39] PCI: Add busn_res into struct pci_bus.
Date: Wed, 29 Feb 2012 15:07:19 -0800
Message-Id: <1330556858-11768-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F4EAFEF.00DB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will use it to have bus number resource tree.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/pci.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index c40fc04..84eedff 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -421,6 +421,7 @@ struct pci_bus {
 	struct list_head slots;		/* list of slots on this bus */
 	struct resource *resource[PCI_BRIDGE_RESOURCE_NUM];
 	struct list_head resources;	/* address space routed to this bus */
+	struct resource busn_res;	/* track registered bus num range */
 
 	struct pci_ops	*ops;		/* configuration access functions */
 	void		*sysdata;	/* hook for sys-specific extension */
-- 
1.7.7

