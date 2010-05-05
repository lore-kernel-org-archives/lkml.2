Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934722Ab0EEMsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:48:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934492Ab0EEMso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:48:44 -0400
Message-ID: <4BE1686D.9000902@cn.fujitsu.com>
Date: Wed, 05 May 2010 20:45:33 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM MMU: fix race in invlpg code
References: <4BE16265.7060004@cn.fujitsu.com> <4BE162B9.201@cn.fujitsu.com> <4BE1650B.7080809@redhat.com>
In-Reply-To: <4BE1650B.7080809@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>>       spin_lock(&vcpu->kvm->mmu_lock);
>> +    index = kvm_page_table_hashfn(gfn);
>> +    bucket =&vcpu->kvm->arch.mmu_page_hash[index];
>> +    hlist_for_each_entry_safe(s, node, tmp, bucket, hash_link)
>> +        if (s == sp) {
>> +            if (s->gfn == gfn&&  s->role.word == role.word)
>> +                live = true;
>> +            break;
>> +        }
>> +
>> +    if (!live)
>> +        goto unlock_exit;
>> +
>>    
> 
> Did you try the root_count method?  I think it's cleaner.

Avi, Thanks for your idea.

I have considered this method, but i'm not sure when it's the good time
to real free this page, and i think we also need a way to synchronize the
real free path and this path. Do you have any comment for it :-(

Xiao
