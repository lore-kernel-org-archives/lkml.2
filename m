Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0J3F5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 01:57:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41823 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab0J3F5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 01:57:43 -0400
Date: Sat, 30 Oct 2010 06:57:37 +0100
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: Mingkai Hu <Mingkai.hu@freescale.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: mtd: fix build error in m25p80.c
Message-ID: <20101030055737.GA2456@angua.secretlab.ca>
References: <20101029210419.70f99e96@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029210419.70f99e96@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 09:04:19PM -0700, Andres Salomon wrote:
> 
> While building an x86 distro kernel, I hit the following:
> 
> Kernel: arch/x86/boot/bzImage is ready  (#7)
> ERROR: "of_mtd_parse_partitions" [drivers/mtd/devices/m25p80.ko]
> undefined!
> 
> of_mtd_parse_partitions is defined with MTD_OF_PARTS, and that's only
> built on PPC and microblaze.  The code in question should be wrapped w/
> a stricter #ifdef.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/mtd/devices/m25p80.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
> index ea22520..184ddd5 100644
> --- a/drivers/mtd/devices/m25p80.c
> +++ b/drivers/mtd/devices/m25p80.c
> @@ -924,7 +924,7 @@ static int __devinit m25p_probe(struct spi_device *spi)
>  			nr_parts = data->nr_parts;
>  		}
>  
> -#ifdef CONFIG_OF
> +#ifdef CONFIG_MTD_OF_PARTS
>  		if (nr_parts <= 0 && spi->dev.of_node) {
>  			nr_parts = of_mtd_parse_partitions(&spi->dev,
>  					spi->dev.of_node, &parts);

True; but CONFIG_MTD_OF_PARTS should be built on all architectures
when CONFIG_OF & CONFIG_MTD_PARTITIONS is set.  I'll craft a patch.

g.
