Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1CGDtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 22:49:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab1CGDtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 22:49:39 -0500
Message-ID: <4D74560D.6060206@cn.fujitsu.com>
Date: Mon, 07 Mar 2011 11:50:37 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/10] KVM: MMU: introduce a common function to get no-dirty-logged
 slot
References: <4D70C569.1030107@cn.fujitsu.com> <4D70C657.4030105@cn.fujitsu.com> <4D737DEE.2050402@redhat.com>
In-Reply-To: <4D737DEE.2050402@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-07 11:48:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-07 11:48:26,
	Serialize complete at 2011-03-07 11:48:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2011 08:28 PM, Avi Kivity wrote:

>>   static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
>> @@ -2155,9 +2166,8 @@ pte_prefetch_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn, bool no_dirty_log)
>>   {
>>       struct kvm_memory_slot *slot;
>>
>> -    slot = gfn_to_memslot(vcpu->kvm, gfn);
>> -    if (!slot || slot->flags&  KVM_MEMSLOT_INVALID ||
>> -          (no_dirty_log&&  slot->dirty_bitmap))
>> +    slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
>> +    if (slot&&  slot->flags&  KVM_MEMSLOT_INVALID)
>>           slot = NULL;
>>
>>       return slot;
> 
> For a unification this adds a lot of code... I think the result is more complicated than the starting point.
> 

After more thinking, i think we can move 'slot->flags&  KVM_MEMSLOT_INVALID'
into the common function, since the later gva_to_pfn also can filter this out.
