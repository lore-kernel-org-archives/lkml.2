Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab2HBBhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 21:37:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40941 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2HBBhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 21:37:13 -0400
From: "Kaneshige, Kenji" <kaneshige.kenji@jp.fujitsu.com>
To: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Don Dutile" <ddutile@redhat.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        "Izumi, Taku" <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v3 08/32] PCI/pciehp: use PCIe capabilities access
 functions to simplify implementation
Thread-Topic: [PATCH v3 08/32] PCI/pciehp: use PCIe capabilities access
 functions to simplify implementation
Thread-Index: AQHNb/41c6iSUR53nUes34QiczC0sZdFvnfg
Date: Thu, 2 Aug 2012 01:37:09 +0000
Message-ID: <4A338DB2991D2A44B9A44B8718AECF650A47B7E7@G01JPEXMBYT03>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
 <1343836477-7287-9-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1343836477-7287-9-git-send-email-jiang.liu@huawei.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v1.7.4
x-originating-ip: [10.124.101.76]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Regards,
Kenji Kaneshige


> -----Original Message-----
> From: Jiang Liu [mailto:liuj97@gmail.com]
> Sent: Thursday, August 02, 2012 12:54 AM
> To: Bjorn Helgaas; Don Dutile
> Cc: Jiang Liu; Yinghai Lu; Izumi, Taku/泉 拓; Rafael J . Wysocki; Kaneshige,
> Kenji/金重 憲治; Yijing Wang; linux-kernel@vger.kernel.org;
> linux-pci@vger.kernel.org; Jiang Liu
> Subject: [PATCH v3 08/32] PCI/pciehp: use PCIe capabilities access
> functions to simplify implementation
> 
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Use PCIe capabilities access functions to simplify pciehp implementation.
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/pci/hotplug/pciehp_acpi.c |    6 +-----
>  drivers/pci/hotplug/pciehp_hpc.c  |   12 ++++--------
>  2 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp_acpi.c
> b/drivers/pci/hotplug/pciehp_acpi.c
> index 376d70d..751b41c 100644
> --- a/drivers/pci/hotplug/pciehp_acpi.c
> +++ b/drivers/pci/hotplug/pciehp_acpi.c
> @@ -81,16 +81,12 @@ static struct list_head __initdata dummy_slots =
> LIST_HEAD_INIT(dummy_slots);
>  /* Dummy driver for dumplicate name detection */
>  static int __init dummy_probe(struct pcie_device *dev)
>  {
> -	int pos;
>  	u32 slot_cap;
>  	acpi_handle handle;
>  	struct dummy_slot *slot, *tmp;
>  	struct pci_dev *pdev = dev->port;
> 
> -	pos = pci_pcie_cap(pdev);
> -	if (!pos)
> -		return -ENODEV;
> -	pci_read_config_dword(pdev, pos + PCI_EXP_SLTCAP, &slot_cap);
> +	pci_pcie_capability_read_dword(pdev, PCI_EXP_SLTCAP,
> &slot_cap);
>  	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
>  	if (!slot)
>  		return -ENOMEM;
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c
> b/drivers/pci/hotplug/pciehp_hpc.c
> index 302451e..cf0daf1 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -44,25 +44,25 @@
>  static inline int pciehp_readw(struct controller *ctrl, int reg, u16
> *value)
>  {
>  	struct pci_dev *dev = ctrl->pcie->port;
> -	return pci_read_config_word(dev, pci_pcie_cap(dev) + reg, value);
> +	return pci_pcie_capability_read_word(dev, reg, value);
>  }
> 
>  static inline int pciehp_readl(struct controller *ctrl, int reg, u32
> *value)
>  {
>  	struct pci_dev *dev = ctrl->pcie->port;
> -	return pci_read_config_dword(dev, pci_pcie_cap(dev) + reg,
> value);
> +	return pci_pcie_capability_read_dword(dev, reg, value);
>  }
> 
>  static inline int pciehp_writew(struct controller *ctrl, int reg, u16
> value)
>  {
>  	struct pci_dev *dev = ctrl->pcie->port;
> -	return pci_write_config_word(dev, pci_pcie_cap(dev) + reg,
> value);
> +	return pci_pcie_capability_write_word(dev, reg, value);
>  }
> 
>  static inline int pciehp_writel(struct controller *ctrl, int reg, u32
> value)
>  {
>  	struct pci_dev *dev = ctrl->pcie->port;
> -	return pci_write_config_dword(dev, pci_pcie_cap(dev) + reg,
> value);
> +	return pci_pcie_capability_write_dword(dev, reg, value);
>  }
> 
>  /* Power Control Command */
> @@ -855,10 +855,6 @@ struct controller *pcie_init(struct pcie_device *dev)
>  		goto abort;
>  	}
>  	ctrl->pcie = dev;
> -	if (!pci_pcie_cap(pdev)) {
> -		ctrl_err(ctrl, "Cannot find PCI Express capability\n");
> -		goto abort_ctrl;
> -	}
>  	if (pciehp_readl(ctrl, PCI_EXP_SLTCAP, &slot_cap)) {
>  		ctrl_err(ctrl, "Cannot read SLOTCAP register\n");
>  		goto abort_ctrl;
> --
> 1.7.9.5

