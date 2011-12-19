Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1LSIcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 03:32:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab1LSIcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 03:32:19 -0500
Message-ID: <4EEEF68D.9000908@redhat.com>
Date: Mon, 19 Dec 2011 10:32:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/8] KVM: MMU: do not add a nonpresent spte to rmaps of
 its child
References: <4EEB19AF.5070501@linux.vnet.ibm.com> <4EEB1A41.7090902@linux.vnet.ibm.com> <4EEEA3D0.9070703@oss.ntt.co.jp>
In-Reply-To: <4EEEA3D0.9070703@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 04:39 AM, Takuya Yoshikawa wrote:
> (2011/12/16 19:15), Xiao Guangrong wrote:
>
>> -static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
>> -                    struct kvm_mmu_page *sp, u64 *parent_pte)
>> +static void mmu_page_add_set_parent_pte(struct kvm_vcpu *vcpu,
>> +                    struct kvm_mmu_page *sp,
>> +                    u64 *parent_pte)
>>   {
>>       if (!parent_pte)
>>           return;
>>
>> +    mmu_spte_set(parent_pte, __pa(sp->spt) | SHADOW_PAGE_TABLE);
>>       pte_list_add(vcpu, parent_pte,&sp->parent_ptes);
>>   }
>
> There are a few prefixes in the kvm mmu code.
>
>     e.g. mmu_page_, kvm_mmu_, kvm_mmu_page_, ...
>
> Sometimes we also use "sp".
>
> How about deciding a consistent way from now on?
>

In general I am in favour of consistency, but I'm not inviting
mass-renaming patches.  Let's try to be consistent in new patches (like
your suggestions on this patchset).

> E.g.
>     if the function is static and for local use only, such a prefix
>     can be eliminated,
>
>     if it is used outside of mmu.c, kvm_mmu_ is needed,
>
>     we use sp for kvm_mmu_page,
>     ...

-- 
error compiling committee.c: too many arguments to function

