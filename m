Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab1DLQtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:49:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37310 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab1DLQt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:49:29 -0400
Date: Tue, 12 Apr 2011 12:48:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org, yinghai@kernel.org, hpa@linux.intel.com,
        mingo@elte.hu
Subject: Re: [PATCH 4/4] xen: do not create the extra e820 region at an
 addr lower than 4G
Message-ID: <20110412164806.GC1067@dumpdata.com>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
 <1302607192-21355-4-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302607192-21355-4-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 12:19:52PM +0100, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Do not add the extra e820 region at a physical address lower than 4G
> because it breaks e820_end_of_low_ram_pfn().
> 
> It is OK for us to move the xen_extra_mem_start up and down because this
> is the index of the memory that can be ballooned in/out - it is memory
> not available to the kernel during bootup.

OK. Stuck it on rc3 queue.

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 9c38bd1..a51e010 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -229,7 +229,7 @@ char * __init xen_memory_setup(void)
>  
>  	memcpy(map_raw, map, sizeof(map));
>  	e820.nr_map = 0;
> -	xen_extra_mem_start = mem_end;
> +	xen_extra_mem_start = max((1ULL << 32), mem_end);
>  	for (i = 0; i < memmap.nr_entries; i++) {
>  		unsigned long long end;
>  
> -- 
> 1.7.2.3
