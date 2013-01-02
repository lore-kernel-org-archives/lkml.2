Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab3ABX1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 18:27:42 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35123 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752711Ab3ABX1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 18:27:40 -0500
Message-ID: <1357169259.25181.9.camel@joe-AO722>
Subject: Re: [PATCH v8 3/3] aerdrv: Cleanup log output for AER
From: Joe Perches <joe@perches.com>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Jan 2013 15:27:39 -0800
In-Reply-To: <20130102232743.5706.63153.stgit@grignak.americas.hpqcorp.net>
References: <20130102232730.5706.82243.stgit@grignak.americas.hpqcorp.net>
	 <20130102232743.5706.63153.stgit@grignak.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-02 at 16:27 -0700, Lance Ortiz wrote:
> These changes make cper_print_aer more consistent with aer_print_error
> and clean things up by elimiating the use of the prefix variable and
> replacing it with dev_printk.
[]
> v7-v8 Updated to use dev_printk instated of prefix. Changed
> log levels to KERN_ERR as per Mauro's suggestion

Just use dev_err( instead of dev_printk(KERN_ERR,
It's a function and it makes the object code smaller.

> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
[]
> @@ -144,26 +143,24 @@ static void __aer_print_error(const char *prefix,
>  				aer_uncorrectable_error_string[i] : NULL;
>  
>  		if (errmsg)
> -			printk("%s""   [%2d] %-22s%s\n", prefix, i, errmsg,
> +			dev_printk(KERN_ERR, &dev->dev,
> +				"   [%2d] %-22s%s\n", i, errmsg,
>  				info->first_error == i ? " (First)" : "");
>  		else
> -			printk("%s""   [%2d] Unknown Error Bit%s\n", prefix, i,
> -				info->first_error == i ? " (First)" : "");
> +			dev_printk(KERN_ERR, &dev->dev,
> +				"   [%2d] Unknown Error Bit%s\n",
> +				i, info->first_error == i ? " (First)" : "");
>  	}
[]
>  	if (info->status == 0) {
> -		printk("%s""PCIe Bus Error: severity=%s, type=Unaccessible, "
> -			"id=%04x(Unregistered Agent ID)\n", prefix,
> +		dev_printk(KERN_ERR, &dev->dev,
> +			"PCIe Bus Error: severity=%s, type=Unaccessible, "
> +			"id=%04x(Unregistered Agent ID)\n",
[]
> @@ -171,22 +168,24 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
[]
> +		dev_printk(KERN_ERR, &dev->dev,
> +			"PCIe Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
> +			aer_error_severity_string[info->severity],
[]
> +		dev_printk(KERN_ERR, &dev->dev,
> +			"  device [%04x:%04x] error status/mask=%08x/%08x\n",
> +			dev->vendor, dev->device,
>  			info->status, info->mask);
[]
> +			dev_printk(KERN_ERR, &dev->dev, "  TLP Header:"
>  				" %02x%02x%02x%02x %02x%02x%02x%02x"
>  				" %02x%02x%02x%02x %02x%02x%02x%02x\n",
[]
> @@ -195,8 +194,9 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
[]
> +		dev_printk(KERN_ERR, &dev->dev,
> +			   "  Error of this Agent(%04x) is reported first\n",
> +			id);
[]
> @@ -244,21 +244,21 @@ void cper_print_aer(const char *prefix, struct pci_dev *dev, int cper_severity,
[]
> +	dev_printk(KERN_ERR, &dev->dev, "aer_status: 0x%08x, aer_mask: 0x%08x\n",
> +	       status, mask);
[]
> +	dev_printk(KERN_ERR, &dev->dev, "aer_layer=%s, aer_agent=%s\n",
>  	       aer_error_layer[layer], aer_agent_string[agent]);
[]
> +		dev_printk(KERN_ERR, &dev->dev, "aer_tlp_header:"


