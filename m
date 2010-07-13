Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab0GME3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 00:29:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58217 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab0GME3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 00:29:40 -0400
Message-ID: <4C3BEAC3.9000501@cn.fujitsu.com>
Date: Tue, 13 Jul 2010 12:25:39 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] KVM: MMU: introduce pte_prefetch_topup_memory_cache()
References: <4C330918.6040709@cn.fujitsu.com> <4C330A37.8080709@cn.fujitsu.com> <4C39C1AB.6000606@redhat.com> <4C3A8694.1000401@cn.fujitsu.com> <4C3B09FD.3060307@redhat.com> <4C3BBE84.30708@cn.fujitsu.com> <4C3BE9BD.40007@redhat.com>
In-Reply-To: <4C3BE9BD.40007@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 07/13/2010 04:16 AM, Xiao Guangrong wrote:
>>
>>
>>> btw, what about dirty logging? will prefetch cause pages to be marked
>>> dirty?
>>>
>>> We may need to instantiate prefetched pages with spte.d=0 and examine it
>>> when tearing down the spte.
>>>
>>>      
>> Yeah, all speculative path are broken dirty bit tracking, and i guess
>> it's
>> need more review, so i plan to do it in the separate patch, i'll post
>> it after
>> this patchset merged, could you allow it?
>>
>>    
> 
> Regressions? no.  Or do you mean the problem already exists?  Where?

I mean this is a exist problem, likes invlpg, pte-write and sync-page, there are
speculative path that it's not real access, but marked dirty if pte is writable.

