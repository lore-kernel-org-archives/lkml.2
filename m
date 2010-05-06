Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0EFHD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:03:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56509 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab0EFHD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:03:56 -0400
Message-ID: <4BE269D4.9090108@cn.fujitsu.com>
Date: Thu, 06 May 2010 15:03:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: reduce 50% memory usage
References: <4BD8228D.7090708@cn.fujitsu.com> <20100429180955.GA17909@amt.cnet> <4BD9D35C.5090403@redhat.com> <20100430154427.GA32340@amt.cnet>
In-Reply-To: <20100430154427.GA32340@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> On Thu, Apr 29, 2010 at 09:43:40PM +0300, Avi Kivity wrote:
>> On 04/29/2010 09:09 PM, Marcelo Tosatti wrote:
>>> You missed quadrant on 4mb large page emulation with shadow (see updated
>>> patch below).
>> Good catch.
>>
>>> Also for some reason i can't understand the assumption
>>> does not hold for large sptes with TDP, so reverted for now.
>> It's unrelated to TDP, same issue with shadow.  I think the
>> calculation is correct.  For example the 4th spte for a level=2 page
>> will yield gfn=4*512.
> 
> Under testing i see sp at level 2, with sp->gfn == 4096, mmu_set_spte
> setting index 8 to gfn 4096 (whereas kvm_mmu_page_get_gfn returns 4096 +
> 8*512).
> 
> Lai, can you please take a look at it? You should see the
> kvm_mmu_page_set_gfn BUG_ON by using -mem-path on hugetlbfs.
> 

Could you tell me how you test it? It will be better if I follow
your test steps.

I also hit the kvm_mmu_page_set_gfn BUG_ON, It is because
FNAME(fetch)() set sp->gfn wrong. The patch:
[PATCH] kvm: calculate correct gfn for small host pages which emulates large guest pages
fix it.

I can not hit kvm_mmu_page_set_gfn BUG_ON after this patch also
applied.

So could you tell me your test steps:
The host: ept/npt enabled? 64bit? testing codes in host?
The guest: OS? PAE? 32bit? 64bit? testing codes in guest?

Lai
