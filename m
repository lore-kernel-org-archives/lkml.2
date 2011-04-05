Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1DERVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:21:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44731 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab1DERVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:21:14 -0400
Message-ID: <4D9B4F69.5050807@kernel.org>
Date: Tue, 05 Apr 2011 10:20:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] x86-32, NUMA: Fix failure condition check in alloc_remap()
References: <1301955840-7246-1-git-send-email-tj@kernel.org> <1301955840-7246-2-git-send-email-tj@kernel.org>
In-Reply-To: <1301955840-7246-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D9B4F79.0008,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 03:23 PM, Tejun Heo wrote:
> node_remap_{start|end}_vaddr[] describe [start, end) ranges; however,
> alloc_remap() incorrectly failed when the current allocation + size
> equaled the end but it should fail only when it goes over.  Fix it.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Thomas Gleixner<tglx@linutronix.de
> Cc: Ingo Molnar<mingo@redhat.com>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> ---
>   arch/x86/mm/numa_32.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index bde3906..84aac47 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -200,7 +200,7 @@ void *alloc_remap(int nid, unsigned long size)
>
>   	size = ALIGN(size, L1_CACHE_BYTES);
>
> -	if (!allocation || (allocation + size)>= node_remap_end_vaddr[nid])
> +	if (!allocation || (allocation + size)>  node_remap_end_vaddr[nid])
>   		return NULL;
>
>   	node_remap_alloc_vaddr[nid] += size;

Acked-by: Yinghai Lu <yinghai@kernel.org>
