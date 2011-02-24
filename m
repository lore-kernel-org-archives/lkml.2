Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1BXO2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:28:22 -0500
Received: from www.tglx.de ([62.245.132.106]:44450 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab1BXO2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:28:21 -0500
Date: Thu, 24 Feb 2011 15:28:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
cc: davinci-linux-open-source@linux.davincidsp.com, hjk@hansjkoch.de,
        gregkh@suse.de, sshtylyov@mvista.com, arnd@arndb.de,
        amit.chatterjee@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/2] PRUSS UIO driver support
In-Reply-To: <1298556402-26456-2-git-send-email-pratheesh@ti.com>
Message-ID: <alpine.LFD.2.00.1102241510450.2701@localhost6.localdomain6>
References: <1298556402-26456-1-git-send-email-pratheesh@ti.com> <1298556402-26456-2-git-send-email-pratheesh@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Pratheesh Gangadhar wrote:

A few nits.

> +static void pruss_cleanup(struct platform_device *dev, struct uio_info *info)
> +{
> +	struct uio_info *p = info;
> +	int cnt;
> +
> +	for (cnt = 0; cnt < MAX_PRUSS_EVT; cnt++, p++) {
> +		uio_unregister_device(p);
> +		kfree(p->name);
> +	}
> +	iounmap(prussio_vaddr);
> +	if (ddr_vaddr) 
> +		dma_free_coherent(&dev->dev, info->mem[2].size,
> +			info->mem[2].internal_addr, info->mem[2].addr);

That is easier to read with curly braces even if they are strictly not
necessary

	if (ddr_vaddr) {
		dma_free_coherent(&dev->dev, info->mem[2].size,
			info->mem[2].internal_addr, info->mem[2].addr);
	}


> +	kfree(info);
> +	clk_put(pruss_clk);
> +}
> +	len = resource_size(regs_ddr);
> +	ddr_vaddr =
> +	dma_alloc_coherent(&dev->dev, len, &ddr_paddr, GFP_KERNEL | GFP_DMA);

That wants to be:
     
	ddr_vaddr = dma_alloc_coherent(&dev->dev, len, &ddr_paddr,
					GFP_KERNEL | GFP_DMA);

Otherwise this looks very clean and readable now and I can't spot any
technical problems with it anymore.

Please fixup the nits and feel free to add

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks for following up on all this!

       tglx
