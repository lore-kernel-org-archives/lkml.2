Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2LVTIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 14:08:16 -0500
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:57205 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab2LVTIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 14:08:15 -0500
Message-ID: <50D6050B.8080400@linux.vnet.ibm.com>
Date: Sat, 22 Dec 2012 17:07:55 -0200
From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        brking@linux.vnet.ibm.com, benh@au1.ibm.com,
        Betty Dall <betty.dall@hp.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] drm: change pci_read_config_dword calls to pcie_capability_read_dword
 ones
References: <50CA5EE2.30206@linux.vnet.ibm.com> <CAErSpo6BfWGYH+=ygS6qWT-YFKPuywooVgLWm+g_eB2dMw3iKQ@mail.gmail.com> <50D60349.7080400@linux.vnet.ibm.com>
In-Reply-To: <50D60349.7080400@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122219-2362-0000-0000-000009513688
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing these calls avoids compatibility problems with PCIe v1/v2
Capability structures.

Signed-off-by: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
---
  drivers/gpu/drm/drm_pci.c |    8 ++------
  1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index ea41234..b824d4c 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -486,17 +486,13 @@ int drm_pcie_get_speed_cap_mask(struct drm_device 
*dev, u32 *mask)
  	if (root == NULL)
  		root = dev->pdev;

-	pos = pci_pcie_cap(root);
-	if (!pos)
-		return -EINVAL;
-
  	/* we've been informed via and serverworks don't make the cut */
  	if (root->vendor == PCI_VENDOR_ID_VIA ||
  	    root->vendor == PCI_VENDOR_ID_SERVERWORKS)
  		return -EINVAL;

-	pci_read_config_dword(root, pos + PCI_EXP_LNKCAP, &lnkcap);
-	pci_read_config_dword(root, pos + PCI_EXP_LNKCAP2, &lnkcap2);
+	pcie_capability_read_dword(root, PCI_EXP_LNKCAP, &lnkcap);
+	pcie_capability_read_dword(root, PCI_EXP_LNKCAP, &lnkcap2);

  	lnkcap &= PCI_EXP_LNKCAP_SLS;
  	lnkcap2 &= 0xfe;
-- 

Lucas Kannebley Tavares
Software Engineer
IBM Linux Technology Center

