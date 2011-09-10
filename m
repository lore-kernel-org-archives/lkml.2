Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab1IJJjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 05:39:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17459 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab1IJJjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 05:39:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=IEkaUmD9vcvTYDph5iOQy8bVAEBJ2YXxGqRzg91kURS2Cj+NkO8cl9fMm/iTsfxY6
	knza81bvHNZaeyEhtc/Qw==
Date: Sat, 10 Sep 2011 02:39:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, tj@kernel.org,
        penberg@kernel.org, yinghai@kernel.org
Subject: Re: [PATCH] arch/x86/mm/numa.c: quiet sparse noise when CONFIG_X86_64
 is not set
In-Reply-To: <201109091638.49186.hartleys@visionengravers.com>
Message-ID: <alpine.DEB.2.00.1109100238110.17756@chino.kir.corp.google.com>
References: <201109091638.49186.hartleys@visionengravers.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Sep 2011, H Hartley Sweeten wrote:

> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index fbeaaf4..11c60a7 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -455,6 +455,7 @@ void __init numa_set_distance(int from, int to, int distance)
>  	numa_distance[from * numa_distance_cnt + to] = distance;
>  }
>  
> +#ifdef CONFIG_X86_64
>  int __node_distance(int from, int to)
>  {
>  	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
> @@ -462,6 +463,7 @@ int __node_distance(int from, int to)
>  	return numa_distance[from * numa_distance_cnt + to];
>  }
>  EXPORT_SYMBOL(__node_distance);
> +#endif
>  
>  /*
>   * Sanity check to catch more bad NUMA configurations (they are amazingly
> 

What is 64-bit specific about this function?  Shouldn't we be defining it 
to be node_distance for all of x86?
