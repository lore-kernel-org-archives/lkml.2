Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab0GMFwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 01:52:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54968 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab0GMFwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 01:52:07 -0400
Message-ID: <4C3BFE12.4060009@cn.fujitsu.com>
Date: Tue, 13 Jul 2010 13:48:02 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] KVM: MMU: introduce pte_prefetch_topup_memory_cache()
References: <4C330918.6040709@cn.fujitsu.com> <4C330A37.8080709@cn.fujitsu.com> <4C39C1AB.6000606@redhat.com> <4C3A8694.1000401@cn.fujitsu.com> <4C3B09FD.3060307@redhat.com> <4C3BBE84.30708@cn.fujitsu.com> <4C3BE9BD.40007@redhat.com> <4C3BEAC3.9000501@cn.fujitsu.com> <4C3BFB25.2010602@redhat.com>
In-Reply-To: <4C3BFB25.2010602@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 07/13/2010 07:25 AM, Xiao Guangrong wrote:
>>
>>> Regressions? no.  Or do you mean the problem already exists?  Where?
>>>      
>> I mean this is a exist problem, likes invlpg, pte-write and sync-page,
>> there are
>> speculative path that it's not real access, but marked dirty if pte is
>> writable.
>>    
> 
> Right.  We should fix those too.
> 
> Prefetch is much more worrying though, especially with ept.  If a guest
> is using just 1/8 of the pages, it can look to migration as if it's
> using 100% of the pages.  The impact can be pretty large.

We disabled prefetch if ept is enabled since it can break access bit tracking.

I'll fix the dirty bit tracking before post the new version of this patchset.
