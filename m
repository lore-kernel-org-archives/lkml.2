Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485Ab0GSKOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 06:14:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:38455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760452Ab0GSKOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 06:14:22 -0400
Message-ID: <4C442549.4030006@kernel.org>
Date: Mon, 19 Jul 2010 12:13:29 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH[RFC] Quirk macbook pro 6,2 into ahci mode
References: <4C4325E0.5020407@fusionio.com> <20100718184243.GA4062@srcf.ucam.org> <4C4383D9.3060705@pobox.com> <4C439B6D.7050103@fusionio.com>
In-Reply-To: <4C439B6D.7050103@fusionio.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 19 Jul 2010 10:13:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/19/2010 02:25 AM, Jens Axboe wrote:
> +static void pch_update_bar(struct pci_dev *pdev)
> +{
> +	if (pcim_iomap_regions(pdev, 1 << 5, "AHCI quirk")) {
> +		int ret;
> +
> +		printk("AHCI BAR not set - attempting to program... ");
> +		pdev->resource[5].flags = IORESOURCE_MEM;
> +		ret = pci_allocate_resource(pdev, 5);
> +		if (ret)
> +			printk (KERN_INFO "Failed to allocate new region\n");
> +		else
> +			printk (KERN_INFO "Succeeded\n");
> +	} else
> +		pcim_iounmap_regions(pdev, 1 << 5);
> +}

Hmm... as the firmware is setting up the resource during boot,
wouldn't it be better to save it and restore it during resume?  That
would be simpler and more robust.

Thanks.

-- 
tejun
