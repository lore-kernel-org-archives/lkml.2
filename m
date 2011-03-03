Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab1CCGaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:30:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37581 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1CCGaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:30:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bWCU7U/rYvMdPJQfJBKqvYvfq5SEdSl4Q2pV8mF/oyWybZCV4RIxghdOv1MTpFAqvl
         EXomlxT9ts/PgkNtiPaYQnMps6Pnsp2qHT/95ejPICV6UbFa8owYLI1HS2OJG49GS6j4
         SnFgui0VV63AZUUG3q8Z3zL7tnDnX5AdEZcCc=
Date: Thu, 3 Mar 2011 07:30:07 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mm: clean up setup_node_bootmem
Message-ID: <20110303063007.GJ28266@mtj.dyndns.org>
References: <4D6EECA1.70603@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6EECA1.70603@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 05:19:29PM -0800, Yinghai Lu wrote:
> only one user now, so change it to static

Can you please try to use proper sentences?  ie.

  There is only one user left now, so make it static.

> Also move validity checking into the fuction.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
...
> Index: linux-2.6/arch/x86/mm/numa_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/numa_64.c
> +++ linux-2.6/arch/x86/mm/numa_64.c
> @@ -237,21 +237,18 @@ int __init numa_add_memblk(int nid, u64
>  }
>  
>  /* Initialize bootmem allocator for a node */
> -void __init
> +static void __init
>  setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
>  {
>  	unsigned long start_pfn, last_pfn, nodedata_phys;
>  	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
>  	int nid;
>  
> -	if (!end)
> -		return;
> -
>  	/*
>  	 * Don't confuse VM with a node that doesn't have the
>  	 * minimum amount of memory:
>  	 */
> -	if (end && (end - start) < NODE_MIN_SIZE)
> +	if (end < (start +  NODE_MIN_SIZE))

Please drop the parentheses.

Thanks.

-- 
tejun
