Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab2K2WLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:11:46 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:32966 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753766Ab2K2WLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:11:44 -0500
Message-ID: <1354227105.1700.15.camel@joe-AO722>
Subject: Re: [PATCH 2/3] aerdrv: Enhanced AER logging
From: Joe Perches <joe@perches.com>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2012 14:11:45 -0800
In-Reply-To: <20121129215450.5483.26562.stgit@grignak.americas.hpqcorp.net>
References: <20121129215443.5483.43364.stgit@grignak.americas.hpqcorp.net>
	 <20121129215450.5483.26562.stgit@grignak.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-29 at 14:54 -0700, Lance Ortiz wrote:
> This patch will provide a more reliable and easy way for user-space
> applications to have access to AER logs rather than reading them from the
> message buffer. It also provides a way to notify user-space when an AER
> event occurs.
[]
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index e6defd8..ef1e1c0 100644
> --- a/drivers/acpi/apei/cper.c
> +++ b/drivers/acpi/apei/cper.c
> @@ -281,9 +281,16 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>  	"%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
>  	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
>  #ifdef CONFIG_ACPI_APEI_PCIEAER
> -	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO) {
> +	dev = pci_get_domain_bus_and_slot(pcie->device_id.segment,
> +			pcie->device_id.bus, pcie->device_id.function);
> +	if (!dev)
> +		pr_info(KERN_INFO, "PCI AER Cannot get PCI device %04x:%02x:%02x.%d\n",
> +			domain, bus, slot, func);

You've not tried this with CONFIG_ACPI_APEI_PCIEAER enabled.

		pr_info("PCI AER Cannot get PCI device %04x:%02x:%02x.%d\n",
			domain, bus, slot, func);


