Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1DER3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:29:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34370 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab1DER3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:29:17 -0400
Message-ID: <4D9B5151.6040604@kernel.org>
Date: Tue, 05 Apr 2011 10:28:49 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] x86-32, NUMA: Align pgdat size while initializing
 alloc_remap
References: <1301955840-7246-1-git-send-email-tj@kernel.org> <1301955840-7246-3-git-send-email-tj@kernel.org>
In-Reply-To: <1301955840-7246-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D9B515D.00A2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 03:23 PM, Tejun Heo wrote:
> When pgdat is reserved in init_remap_allocator(), PAGE_SIZE aligned
> size will be used.  Match the size alignment in initialization to
> avoid allocation failure down the road.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Thomas Gleixner<tglx@linutronix.de
> Cc: Ingo Molnar<mingo@redhat.com>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> ---
>   arch/x86/mm/numa_32.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index 84aac47..50e8250 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -287,7 +287,8 @@ static __init unsigned long calculate_numa_remap_pages(void)
>   			node_end_pfn[nid] = max_pfn;
>
>   		/* ensure the remap includes space for the pgdat. */
> -		size = node_remap_size[nid] + sizeof(pg_data_t);
> +		size = node_remap_size[nid];
> +		size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
>
>   		/* convert size to large (pmd size) pages, rounding up */
>   		size = (size + LARGE_PAGE_BYTES - 1) / LARGE_PAGE_BYTES;

Acked-by: Yinghai Lu <yinghai@kernel.org>
