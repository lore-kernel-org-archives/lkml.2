Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2HXIPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 04:15:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:17306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab2HXIPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 04:15:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,302,1344236400"; 
   d="scan'208";a="210298913"
Message-ID: <50373815.2080704@intel.com>
Date: Fri, 24 Aug 2012 16:15:17 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: apparent regressions from TLB range flushing page set
References: <503261F00200007800096710@nat28.tlf.novell.com> <503450C1.8070600@intel.com> <50349AB4020000780008A4B5@nat28.tlf.novell.com> <50349E45.3020502@intel.com> <5034F9510200007800096E97@nat28.tlf.novell.com>
In-Reply-To: <5034F9510200007800096E97@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 09:22 PM, Jan Beulich wrote:

>>>> On 22.08.12 at 10:54, Alex Shi <alex.shi@intel.com> wrote:
>> On 08/22/2012 03:39 PM, Jan Beulich wrote:
>>
>>>>>> Alex Shi <alex.shi@intel.com> 08/22/12 5:24 AM >>>
>>>> On 08/20/2012 10:12 PM, Jan Beulich wrote:
>>>> I was thought you have 'Agreed' for xen part code. :)
>>>
>>> I had agreed to it being done the right way, and I had pointed out the
>>> problem once. I can't say for sure that I looked at the most recent rev
>>> closely enough to spot the issue still being unfixed.
>>>
>>>>> For one, while TLB_FLUSH_ALL gets passed as 'end' argument to
>>>>> flush_tlb_others(), the Xen code was made to check its 'start'
>>>>> parameter.
>>>>
>>>> Do you mean need the following change? --untested.
>>>
>>> Yes. I'd question though whether for that special case it shouldn't be
>>> start _and_ end to get passed the special value.
>>
>>
>> Actually the special value is already there in old code.
>> so, what's your meaning of the question?
> 
> I'm saying that I'd rather see
> 
> #define flush_tlb_mm(mm)	flush_tlb_mm_range(mm, TLB_FLUSH_ALL, TLB_FLUSH_ALL, 0UL)


It bring logical confusing, and is no much help.
flush_tlb_mm_range still will call:
flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);

So, since we already fix code error, we'd better not to do this change.


>

> Jan
> 


