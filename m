Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2E1PKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:10:50 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:55858 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2E1PKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:10:49 -0400
Message-ID: <4FC39572.6010709@linux.vnet.ibm.com>
Date: Mon, 28 May 2012 20:40:42 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu
Subject: Re: [PATCH] perf record: fix branch_stack type in perf_record_opts
References: <20120525211344.GA7729@quad>
In-Reply-To: <20120525211344.GA7729@quad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12052815-5564-0000-0000-000002FAC216
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2012 02:43 AM, Stephane Eranian wrote:

> 
> The attr.branch_sample_type field is defined as u64 by the API.
> As such, we need to ensure the variable holding the value of the
> branch stack filters is also u64 otherwise we may lose bits in
> the future.
> 
> Note also that the bogus definition of the field in
> perf_record_opts caused problems on big-endian PPC systems.
> Thanks to Anshuman Khandual for tracking the problem on PPC.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>


Acked-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>

> ---
> 
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 14f1034..f960ccb 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -227,7 +227,7 @@ struct perf_record_opts {
>  	unsigned int freq;
>  	unsigned int mmap_pages;
>  	unsigned int user_freq;
> -	int	     branch_stack;
> +	u64          branch_stack;
>  	u64	     default_interval;
>  	u64	     user_interval;
>  };
> 


