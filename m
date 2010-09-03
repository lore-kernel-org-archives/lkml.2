Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab0ICKH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:07:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:1471 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab0ICKH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:07:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,312,1280732400"; 
   d="scan'208";a="834544489"
Message-ID: <4C80C8FB.6070902@linux.intel.com>
Date: Fri, 03 Sep 2010 18:07:55 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the tip tree
References: <20100903121023.54c40e73.sfr@canb.auug.org.au> <20100903121201.336c4ba8.sfr@canb.auug.org.au> <20100903090407.GA19771@localhost>
In-Reply-To: <20100903090407.GA19771@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> On Fri, Sep 03, 2010 at 10:12:01AM +0800, Stephen Rothwell wrote:
>> On Fri, 3 Sep 2010 12:10:23 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
>>> produced this warning:
>>>
>>> arch/x86/mm/init_64.c: In function 'kernel_physical_mapping_init':
>>> arch/x86/mm/init_64.c:601: warning: 'addr' may be used uninitialized in this function
>>>
>>> The code does look suspicious ... 'addr' gets declared and then passed to
>>> a function, but is not set anywhere ...
>> Forgot to say:
>>
>> Introduced by commit 9b861528a8012e7bc4d1f7bae07395b225331477 ("x86-64,
>> mem: Update all PGDs for direct mapping and vmemmap mapping changes").
> 
> 
> The original patch has the following line, however get lost some time
> later:
> 
>         http://www.spinics.net/lists/linux-mm/msg08152.html
> 
> ===
> x86, mm: fix uninitialized addr in kernel_physical_mapping_init()
> 
> This re-adds the lost chunk in commit 9b861528a80.
> 
> CC: Haicheng Li <haicheng.li@linux.intel.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 64e7bc2..74f0f35 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -570,6 +570,7 @@ kernel_physical_mapping_init(unsigned long start,
>  
>  	start = (unsigned long)__va(start);
>  	end = (unsigned long)__va(end);
> +	addr = start;

weird, this line was in my original patch: http://lkml.org/lkml/2010/8/20/166

Acked-by: Haicheng Li <haicheng.li@linux.intel.com>

>  	for (; start < end; start = next) {
>  		pgd_t *pgd = pgd_offset_k(start);
> 
