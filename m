Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2HMVkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:40:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46671 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2HMVkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:40:15 -0400
Message-ID: <50297434.8090806@gmail.com>
Date: Mon, 13 Aug 2012 14:40:04 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>, Ralf Baechle <ralf@linux-mips.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 13/32] PCI/MIPS: use PCIe capabilities access functions
 to simplify implementation
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com> <1343836477-7287-14-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1343836477-7287-14-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 08:54 AM, Jiang Liu wrote:
> From: Jiang Liu<jiang.liu@huawei.com>
>
> Use PCIe capabilities access functions to simplify PCIe MIPS implementation.
>
> Signed-off-by: Jiang Liu<liuj97@gmail.com>

Acked-by: David Daney <david.daney@cavium.com>

> ---
>   arch/mips/pci/pci-octeon.c |   15 +++++----------
>   1 file changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
> index 52a1ba7..aaed2ad 100644
> --- a/arch/mips/pci/pci-octeon.c
> +++ b/arch/mips/pci/pci-octeon.c
> @@ -117,16 +117,11 @@ int pcibios_plat_dev_init(struct pci_dev *dev)
>   	}
>
>   	/* Enable the PCIe normal error reporting */
> -	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
> -	if (pos) {
> -		/* Update Device Control */
> -		pci_read_config_word(dev, pos + PCI_EXP_DEVCTL,&config);
> -		config |= PCI_EXP_DEVCTL_CERE; /* Correctable Error Reporting */
> -		config |= PCI_EXP_DEVCTL_NFERE; /* Non-Fatal Error Reporting */
> -		config |= PCI_EXP_DEVCTL_FERE;  /* Fatal Error Reporting */
> -		config |= PCI_EXP_DEVCTL_URRE;  /* Unsupported Request */
> -		pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, config);
> -	}
> +	config = PCI_EXP_DEVCTL_CERE; /* Correctable Error Reporting */
> +	config |= PCI_EXP_DEVCTL_NFERE; /* Non-Fatal Error Reporting */
> +	config |= PCI_EXP_DEVCTL_FERE;  /* Fatal Error Reporting */
> +	config |= PCI_EXP_DEVCTL_URRE;  /* Unsupported Request */
> +	pci_pcie_capability_change_word(dev, PCI_EXP_DEVCTL, config, 0);
>
>   	/* Find the Advanced Error Reporting capability */
>   	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);

