Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965486Ab2JCRwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:52:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34335 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965427Ab2JCRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:52:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>, yuvalmin@broadcom.com,
        bhutchings@solarflare.com, gregory.v.rose@intel.com,
        davem@davemloft.net--no-chain-reply-to,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/5] PCI: add set_max_vfs in pci_driver ops
Date: Wed,  3 Oct 2012 10:51:33 -0700
Message-Id: <1349286695-26713-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349286695-26713-1-git-send-email-yinghai@kernel.org>
References: <506C3B11.9010009@redhat.com>
 <1349286695-26713-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will use it enable sriov for pci devices.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/pci.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index be1de01..7d70a5e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -590,6 +590,7 @@ struct pci_driver {
 	const struct pci_device_id *id_table;	/* must be non-NULL for probe to be called */
 	int  (*probe)  (struct pci_dev *dev, const struct pci_device_id *id);	/* New device inserted */
 	void (*remove) (struct pci_dev *dev);	/* Device removed (NULL if not a hot-plug capable driver) */
+	void (*set_max_vfs) (struct pci_dev *dev); /* enable sriov */
 	int  (*suspend) (struct pci_dev *dev, pm_message_t state);	/* Device suspended */
 	int  (*suspend_late) (struct pci_dev *dev, pm_message_t state);
 	int  (*resume_early) (struct pci_dev *dev);
-- 
1.7.7

