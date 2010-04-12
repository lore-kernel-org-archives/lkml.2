Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0DLLWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 07:22:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab0DLLWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 07:22:34 -0400
Message-ID: <4BC30273.3050406@redhat.com>
Date: Mon, 12 Apr 2010 14:22:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] KVM MMU: optimize for writing cr4
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D3E0.8070602@cn.fujitsu.com> <4BC2DB27.7060005@redhat.com> <4BC2F928.2060407@cn.fujitsu.com>
In-Reply-To: <4BC2F928.2060407@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 01:42 PM, Xiao Guangrong wrote:
> Hi Avi,
>
> Thanks for your comments.
>
> Avi Kivity wrote:
>
>    
>> Later we have:
>>
>>      
>>>          kvm_x86_ops->set_cr4(vcpu, cr4);
>>>          vcpu->arch.cr4 = cr4;
>>>          vcpu->arch.mmu.base_role.cr4_pge = (cr4&  X86_CR4_PGE)&&
>>> !tdp_enabled;
>>>        
>> All of which depend on cr4.
>>      
> Oh, destroy_kvm_mmu() is not really destroyed cr3 and we can reload it later
> form shadow page cache, so, maybe this patch is unnecessary.
>
> But, i have a another question here, why we need encode 'cr4&  X86_CR4_PGE' into
> base_role.cr4_gpe? Why we need allocation different shadow page for global page
> and no-global page?
>    

See 6364a3918cb.  It was reverted later due to a problem with the 
implementation.  I'm not sure whether I want to fix the bug and restore 
that patch, or to drop it altogether and give the guest ownership of 
cr4.pge.  See cr4_guest_owned_bits (currently only used on ept).

> As i know, global page is not static in TLB, and x86 cpu also may flush them form TLB,
> maybe we no need treat global page specially... Am i miss something? :-(
>    

You can't read reverted patches? :)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

