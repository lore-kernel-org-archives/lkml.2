Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab1D3QcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 12:32:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52499 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab1D3QcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 12:32:07 -0400
Message-ID: <4DBC3976.7030205@kernel.org>
Date: Sat, 30 Apr 2011 09:31:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET tip] x86, NUMA: Unify 32 and 64bit NUMA initialization
References: <1304090924-8197-1-git-send-email-tj@kernel.org> <4DBB1C16.3070307@kernel.org> <20110430121734.GF29280@htj.dyndns.org>
In-Reply-To: <20110430121734.GF29280@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DBC397A.0077,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2011 05:17 AM, Tejun Heo wrote:
> Hello, Yinghai.
> 
> Nice catch, but,
> 
> On Fri, Apr 29, 2011 at 01:14:14PM -0700, Yinghai Lu wrote:
>> [PATCH] x86, numa: Trim numa meminfo correctly
>>
>> During testing 32bit numa unifying code from tj, found one system with more than 64g
>> fail to use numa.
>>
>> It turn out we do not trim that numa meminfo correctly with max_pfn.
>> start could be bigger than 64g too.
>>
>> Also need to make the checking in seperated loop.
> 
> Why?

so do not need to compare them with low/high in following inner loop.


> 
> Isn't all that necessary the following?
> 
> ---
>  arch/x86/mm/numa.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: work/arch/x86/mm/numa.c
> ===================================================================
> --- work.orig/arch/x86/mm/numa.c
> +++ work/arch/x86/mm/numa.c
> @@ -278,7 +278,7 @@ int __init numa_cleanup_meminfo(struct n
>  		bi->end = min(bi->end, high);
>  
>  		/* and there's no empty block */
> -		if (bi->start == bi->end) {
> +		if (bi->start >= bi->end) {
>  			numa_remove_memblk_from(i--, mi);
>  			continue;
>  		}

