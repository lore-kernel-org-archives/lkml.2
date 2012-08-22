Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab2HVNWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:22:22 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40393 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2HVNWS convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 22 Aug 2012 09:22:18 -0400
Message-Id: <5034F9510200007800096E97@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 22 Aug 2012 14:22:57 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Alex Shi" <alex.shi@intel.com>
Cc: <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: apparent regressions from TLB range flushing page set
References: <503261F00200007800096710@nat28.tlf.novell.com>
 <503450C1.8070600@intel.com>
 <50349AB4020000780008A4B5@nat28.tlf.novell.com>
 <50349E45.3020502@intel.com>
In-Reply-To: <50349E45.3020502@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.08.12 at 10:54, Alex Shi <alex.shi@intel.com> wrote:
> On 08/22/2012 03:39 PM, Jan Beulich wrote:
> 
>>>>> Alex Shi <alex.shi@intel.com> 08/22/12 5:24 AM >>>
>>> On 08/20/2012 10:12 PM, Jan Beulich wrote:
>>> I was thought you have 'Agreed' for xen part code. :)
>> 
>> I had agreed to it being done the right way, and I had pointed out the
>> problem once. I can't say for sure that I looked at the most recent rev
>> closely enough to spot the issue still being unfixed.
>> 
>>>> For one, while TLB_FLUSH_ALL gets passed as 'end' argument to
>>>> flush_tlb_others(), the Xen code was made to check its 'start'
>>>> parameter.
>>>
>>> Do you mean need the following change? --untested.
>> 
>> Yes. I'd question though whether for that special case it shouldn't be
>> start _and_ end to get passed the special value.
> 
> 
> Actually the special value is already there in old code.
> so, what's your meaning of the question?

I'm saying that I'd rather see

#define flush_tlb_mm(mm)	flush_tlb_mm_range(mm, TLB_FLUSH_ALL, TLB_FLUSH_ALL, 0UL)

Jan

