Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370Ab0FQRIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:08:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:58554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760291Ab0FQRIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:08:13 -0400
Message-ID: <4C1A5679.8010907@kernel.org>
Date: Thu, 17 Jun 2010 19:08:09 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: per_cpu_ptr_to_phys() failure on UV x86_64
References: <E1OPHpK-0007cw-S5@eag09.americas.sgi.com>
In-Reply-To: <E1OPHpK-0007cw-S5@eag09.americas.sgi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Jun 2010 17:08:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/17/2010 06:20 PM, Cliff Wickman wrote:
>  phys_addr_t per_cpu_ptr_to_phys(void *addr)
>  {
> +	if ((unsigned long)addr < VMALLOC_START ||
> +	    (unsigned long)addr >= VMALLOC_END)
> +		return __pa(addr);
>  	if (pcpu_addr_in_first_chunk(addr)) {
> -		if ((unsigned long)addr < VMALLOC_START ||
> -		    (unsigned long)addr >= VMALLOC_END)
> -			return __pa(addr);
> -		else
> -			return page_to_phys(vmalloc_to_page(addr));
> +		return page_to_phys(vmalloc_to_page(addr));
>  	} else
>  		return page_to_phys(pcpu_addr_to_page(addr));
>  }

(scratching head...) So, that means it's given an address for which
!pcpu_addr_in_first_chunk() but outside of vmalloc area.  Strange.
I'll find out what's going on.

Thanks.

-- 
tejun
