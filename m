Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab0D3RQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:16:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608Ab0D3RQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:16:01 -0400
Message-ID: <4BDAAA39.4030509@redhat.com>
Date: Fri, 30 Apr 2010 13:00:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: reduce 50% memory usage
References: <4BD8228D.7090708@cn.fujitsu.com> <20100429180955.GA17909@amt.cnet> <4BD9D35C.5090403@redhat.com> <4BDA3F9B.8040708@cn.fujitsu.com> <4BDA863A.9060702@redhat.com> <4BDA9AAC.6060303@cn.fujitsu.com>
In-Reply-To: <4BDA9AAC.6060303@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2010 11:54 AM, Lai Jiangshan wrote:
> Avi Kivity wrote:
>    
>> On 04/30/2010 05:25 AM, Lai Jiangshan wrote:
>>      
>>>        
>>>> It's unrelated to TDP, same issue with shadow.  I think the calculation
>>>> is correct.  For example the 4th spte for a level=2 page will yield
>>>> gfn=4*512.
>>>>
>>>>          
>>> Avi, Marcelo
>>> Thank you very much.
>>>
>>> The calculation I used is correct.
>>>
>>>        
>> Yes.  btw, can you update the patch to also correct mmu.txt?
>>      
> The corresponding content in mmu.txt are:
>    role.direct:
>      If set, leaf sptes reachable from this page are for a linear range.
>      Examples include real mode translation, large guest pages backed by small
>      host pages, and gpa->hpa translations when NPT or EPT is active.
>      The linear range starts at (gfn<<  PAGE_SHIFT) and its size is determined
>      by role.level (2MB for first level, 1GB for second level, 0.5TB for third
>      level, 256TB for fourth level)
>      If clear, this page corresponds to a guest page table denoted by the gfn
>      field.
>
>    gfn:
>      Either the guest page table containing the translations shadowed by this
>      page, or the base page frame for linear translations.  See role.direct.
>
> These are correct. My patch is fully base on this document.
> I think it is not need to be fixed.
>
> Did I miss something?
>
>    

sp->gfns can now be NULL, so the documentation of this field needs to be 
updated.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

