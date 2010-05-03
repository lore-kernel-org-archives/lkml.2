Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab0ECVqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:46:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37926 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab0ECVqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:46:39 -0400
Message-ID: <4BDF4407.8000503@zytor.com>
Date: Mon, 03 May 2010 14:45:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Suresh Siddha <suresh.b.siddha@intel.com>
CC: Brian Gerst <brgerst@gmail.com>, Dexuan Cui <dexuan.cui@intel.com>,
       Sheng Yang <sheng@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: eliminate TS_XSAVE
References: <1272812038-32484-1-git-send-email-avi@redhat.com>	 <1272812038-32484-2-git-send-email-avi@redhat.com> <u2p73c1f2161005021038gce35c1bbpca6ec119d24e646e@mail.gmail.com> <4BDDBA18.3080909@redhat.com>
In-Reply-To: <4BDDBA18.3080909@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2010 10:44 AM, Avi Kivity wrote:
> On 05/02/2010 08:38 PM, Brian Gerst wrote:
>> On Sun, May 2, 2010 at 10:53 AM, Avi Kivity<avi@redhat.com>  wrote:
>>    
>>> The fpu code currently uses current->thread_info->status&  TS_XSAVE as
>>> a way to distinguish between XSAVE capable processors and older processors.
>>> The decision is not really task specific; instead we use the task status to
>>> avoid a global memory reference - the value should be the same across all
>>> threads.
>>>
>>> Eliminate this tie-in into the task structure by using an alternative
>>> instruction keyed off the XSAVE cpu feature; this results in shorter and
>>> faster code, without introducing a global memory reference.
>>>      
>> I think you should either just use cpu_has_xsave, or extend this use
>> of alternatives to all cpu features.  It doesn't make sense to only do
>> it for xsave.
>>    
> 
> I was trying to avoid a performance regression relative to the current 
> code, as it appears that some care was taken to avoid the memory reference.
> 
> I agree that it's probably negligible compared to the save/restore 
> code.  If the x86 maintainers agree as well, I'll replace it with 
> cpu_has_xsave.
> 

I asked Suresh to comment on this, since he wrote the original code.  He
did confirm that the intent was to avoid a global memory reference.

	-hpa

