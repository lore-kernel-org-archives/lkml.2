Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2GKJB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:01:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37384 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2GKJB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:01:26 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Wed, 11 Jul 2012 18:01:12 +0900
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH 01/14] PCI: add pcie_flags into struct pci_dev to
 cache PCIe capabilities register
Message-Id: <20120711180112.3ae76a2e.izumi.taku@jp.fujitsu.com>
In-Reply-To: <1341935655-5381-2-git-send-email-jiang.liu@huawei.com>
References: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
	<1341935655-5381-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012 23:54:02 +0800
Jiang Liu <liuj97@gmail.com> wrote:

> From: Yijing Wang <wangyijing@huawei.com>
> 
> From: Yijing Wang <wangyijing@huawei.com>
> 
> Since PCI Express Capabilities Register is read only, cache its value
> into struct pci_dev to avoid repeatedly calling pci_read_config_*().
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  drivers/pci/probe.c |    1 +
>  include/linux/pci.h |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 6c143b4..65e82e3 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -929,6 +929,7 @@ void set_pcie_port_type(struct pci_dev *pdev)
>  	pdev->is_pcie = 1;
>  	pdev->pcie_cap = pos;
>  	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
> +	pdev->pcie_flags = reg16;
>  	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
>  	pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP, &reg16);
>  	pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 5faa831..f4a7ad6 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -258,6 +258,7 @@ struct pci_dev {
>  	u8		pcie_mpss:3;	/* PCI-E Max Payload Size Supported */
>  	u8		rom_base_reg;	/* which config register controls the ROM */
>  	u8		pin;  		/* which interrupt pin this device uses */
> +	u16		pcie_flags;	/* cached PCI-E Capabilities Register */

 "xxx_flags" sounds like a bit flag. This variable stores a value of PCIe capability 
 register, doesn't it?   How about "pcie_cap_reg" ?

>  
>  	struct pci_driver *driver;	/* which driver has allocated this device */
>  	u64		dma_mask;	/* Mask of the bits of bus address this
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Taku Izumi <izumi.taku@jp.fujitsu.com>

