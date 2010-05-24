Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0EXGZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 02:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0EXGZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 02:25:35 -0400
Message-ID: <4BFA1BD9.5070302@redhat.com>
Date: Mon, 24 May 2010 09:25:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: MMU: allow more page become unsync at getting
 sp time
References: <4BF91C34.6020904@cn.fujitsu.com> <4BF91C82.8050308@cn.fujitsu.com> <4BF9378B.4080703@redhat.com> <4BF9E50B.6010205@cn.fujitsu.com>
In-Reply-To: <4BF9E50B.6010205@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 05:31 AM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>    
>> On 05/23/2010 03:16 PM, Xiao Guangrong wrote:
>>      
>>> Allow more page become asynchronous at getting sp time, if need create
>>> new
>>> shadow page for gfn but it not allow unsync(level>   1), we should
>>> unsync all
>>> gfn's unsync page
>>>
>>>
>>>
>>> +/* @gfn should be write-protected at the call site */
>>> +static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
>>> +{
>>> +    struct hlist_head *bucket;
>>> +    struct kvm_mmu_page *s;
>>> +    struct hlist_node *node, *n;
>>> +    unsigned index;
>>> +    bool flush = false;
>>> +
>>> +    index = kvm_page_table_hashfn(gfn);
>>> +    bucket =&vcpu->kvm->arch.mmu_page_hash[index];
>>> +    hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
>>>
>>>        
>> role.direct, role.invalid?
>>      
> We only handle unsync pages here, and 'role.direct' or 'role.invalid'
> pages can't become unsync.
>    

They will be once the invlpg patch is in...

>    
>> Well, role.direct cannot be unsync.  But that's not something we want to
>> rely on.
>>      
> While we mark the unsync page, we have filtered out the 'role.direct' pages,
> so, i think we not need worry 'role.direct' here. :-)
>    

Ok.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

