Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab1JXNIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:08:45 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:63722 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab1JXNIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:08:43 -0400
Date: Thu, 20 Oct 2011 20:40:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, fujita.tomonori@lab.ntt.co.jp
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86 swiotlb: Verify we can perform the remapping
 requested.
Message-ID: <20111021004031.GB13687@phenom.dumpdata.com>
References: <m1lisj48q1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lisj48q1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4EA56319.019D:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 02:19:18PM -0700, Eric W. Biederman wrote:
> 
> Recently I had a driver try with a peculiar 2G dma memory limit.
> It failed in weird and strange ways because my bounce buffers were
> being allocated above 2G where the driver could not reach, and
> no error was reported when the mappings were setup.

OK, so the overflow buffer was used instead.. which presumarily
also was allocated above the 2G? That seems to point that
alloc_bootmem_low_pages is not doing its job?

> 
> Use the swiotlb_dma_supported to avoid silent problems like this
> in the future.

Which driver was it that had this limit?

> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

I also CC-ed Fujita on this as he is the swiotlb maintainer.

> ---
>  arch/x86/kernel/pci-swiotlb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index 8f972cb..6a802fa 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -38,7 +38,7 @@ static struct dma_map_ops swiotlb_dma_ops = {
>  	.unmap_sg = swiotlb_unmap_sg_attrs,
>  	.map_page = swiotlb_map_page,
>  	.unmap_page = swiotlb_unmap_page,
> -	.dma_supported = NULL,
> +	.dma_supported = swiotlb_dma_supported,
>  };
>  
>  /*
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
