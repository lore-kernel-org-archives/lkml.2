Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2ITNs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:48:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab2ITNs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:48:26 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=WnYo-2BfFuEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=-t9bLuw0o0EA:10 a=omOdbC7AAAAA:8 a=t5L4QVpALLbyYhDqEvYA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348148904.13080.63.camel@gandalf.local.home>
Subject: Re: [PATCH] trace: don't call page_to_pfn() if page is NULL
From: Steven Rostedt <rostedt@goodmis.org>
To: Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mel@csn.ul.ie>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, khlebnikov@openvz.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Sep 2012 09:48:24 -0400
In-Reply-To: <505AB1FF.8020104@cn.fujitsu.com>
References: <505AB1FF.8020104@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel,

As you were the original author of this code, can I get your Acked-by?

Thanks,

-- Steve


On Thu, 2012-09-20 at 14:04 +0800, Wen Congyang wrote:
> When allocating memory fails, page is NULL. page_to_pfn() will
> cause the kernel panicked if we don't use sparsemem vmemmap.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> 
> ---
>  include/trace/events/kmem.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
> index 5f889f1..08fa272 100644
> --- a/include/trace/events/kmem.h
> +++ b/include/trace/events/kmem.h
> @@ -214,7 +214,7 @@ TRACE_EVENT(mm_page_alloc,
>  
>  	TP_printk("page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s",
>  		__entry->page,
> -		page_to_pfn(__entry->page),
> +		__entry->page ? page_to_pfn(__entry->page) : 0,
>  		__entry->order,
>  		__entry->migratetype,
>  		show_gfp_flags(__entry->gfp_flags))
> @@ -240,7 +240,7 @@ DECLARE_EVENT_CLASS(mm_page,
>  
>  	TP_printk("page=%p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
>  		__entry->page,
> -		page_to_pfn(__entry->page),
> +		__entry->page ? page_to_pfn(__entry->page) : 0,
>  		__entry->order,
>  		__entry->migratetype,
>  		__entry->order == 0)


