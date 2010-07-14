Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab0GNN2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:28:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53761 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab0GNN2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:28:51 -0400
Message-ID: <4C3DBA97.40908@cn.fujitsu.com>
Date: Wed, 14 Jul 2010 21:24:39 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/4] KVM: MMU: fix forgot reserved bits check in speculative
 path
References: <4C3C3518.7080505@cn.fujitsu.com> <4C3DB671.1090802@redhat.com>
In-Reply-To: <4C3DB671.1090802@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>> +
>> +            if (!!is_pae(vcpu) != sp->role.cr4_pae ||
>> +                  is_nx(vcpu) != sp->role.nxe)
>> +                continue;
>> +
>>    
> 
> Do we also need to check cr0.wp?  I think so.

I think it's not too bad since we just decrease the access right, for example,
we mark the mapping readonly for cr0.wp=0's page, the later write-access will
cause #PF, and the read-access is OK.

> 
>>               if (gentry)
>>                   mmu_pte_write_new_pte(vcpu, sp, spte,&gentry);
>>    
> 
> Please move the checks to mmu_pte_write_new_pte(), it's a more logical
> place.
> 
> It means the reserved bits check happens multiple times, but that's ok.
> 

OK

> Also, you can use arch.mmu.base_role to compare:
> 
>     static const kvm_mmu_page_role mask = { .level = -1U, .cr4_pae = 1,
> ... };
> 
>     if ((sp->role.word ^ base_role.word) & mask.word)
>          return;

OK, will update it :-)
