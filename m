Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0DECTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 22:19:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:52525 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab0DECTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 22:19:30 -0400
Date: Mon, 5 Apr 2010 11:13:02 +0900
To: konrad.wilk@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       Ian.Campbell@eu.citrix.com, jeremy@goop.org, chrisw@sous-sol.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Subject: Re: [PATCH 4/5] swiotlb: Make swiotlb bookkeeping functions
 visible in	the header file.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1269011062-25915-5-git-send-email-konrad.wilk@oracle.com>
References: <1269011062-25915-3-git-send-email-konrad.wilk@oracle.com>
	<1269011062-25915-4-git-send-email-konrad.wilk@oracle.com>
	<1269011062-25915-5-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100405111222G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 05 Apr 2010 11:13:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010 11:04:21 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> We put the init, free, and functions dealing with the operations on the
> SWIOTLB buffer at the top of the header. Also we export some of the variables
> that are used by the dma_ops functions.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  include/linux/swiotlb.h |   33 +++++++++++++++++++++++++++++++++
>  lib/swiotlb.c           |   28 ++++++++++------------------
>  2 files changed, 43 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index febedcf..8550d6b 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -24,6 +24,39 @@ extern int swiotlb_force;
>  
>  extern void swiotlb_init(int verbose);
>  
> +/* Internal book-keeping functions. Must be linked against the library
> + * to take advantage of them.*/
> +#ifdef CONFIG_SWIOTLB
> +/*
> + * Enumeration for sync targets
> + */
> +enum dma_sync_target {
> +	SYNC_FOR_CPU = 0,
> +	SYNC_FOR_DEVICE = 1,
> +};
> +extern char *swiotlb_bk_start;
> +extern char *swiotlb_bk_end;
> +extern unsigned long swiotlb_bk_nslabs;

exporting swiotlb_bk_start and swiotlb_bk_nslabs aren't enough?


> +extern void *swiotlb_bk_overflow_buffer;
> +extern unsigned long swiotlb_bk_overflow;
> +extern int is_swiotlb_buffer(phys_addr_t paddr);
> +extern void *swiotlb_bk_map_single(struct device *hwdev, phys_addr_t phys,
> +			    unsigned long start_dma_addr, size_t size, int dir);

enum dma_data_direction is better for 'dir'.
