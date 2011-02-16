Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1BPWnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:43:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56155 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1BPWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:43:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sQi5aZX6ewFMUdsuN/iydjGQJwcEhi47ByS6jjB/BGJif2ig+X2ybYdHMvvvZ54r2C
         Ymz5lZEXmoRPnA5rVGmwG/AdsZRAjLBb8+EHaXZdkHYF9jrhJ+TLylT/ARIIvz839u+o
         ON3FH9hGOxyxhKSXTVGxRz4SNPOO85yzFR7As=
Date: Wed, 16 Feb 2011 23:43:22 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: refactoring numa_register_memblks
Message-ID: <20110216224322.GB29600@atj.dyndns.org>
References: <4D5C3A0F.3080107@kernel.org>
 <4D5C3A81.4070408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C3A81.4070408@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 16, 2011 at 12:58:41PM -0800, Yinghai Lu wrote:
> 
> Don't hide init_memory_mapping and setup_bootmem into that __register__ function
> 
> those are really work.

What does that mean?  What isn't really work?

> Also We don't need to scan two times for setup_node_bootmem() becase we
> are using mapped memblock for node_data already.

If this isn't necessary, please make this change in a separate patch.
This involves behavior change.

> @@ -968,6 +969,10 @@ void __init initmem_init(void)
>  		if (numa_register_memblks(&numa_meminfo) < 0)
>  			continue;
>  
> +		init_memory_mapping_high();
> +
> +		setup_numa_bootmem(&numa_meminfo);
> +

Sorry, nack.  This squarely falls in the realm of bikeshedding and I
plan on collapsing init_memory_mapping_high() into the register
function.

Thanks.

--
tejun
