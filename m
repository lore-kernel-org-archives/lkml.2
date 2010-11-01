Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0KAJaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:30:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58668 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab0KAJa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:30:26 -0400
Message-ID: <4CCE89BA.9090708@cn.fujitsu.com>
Date: Mon, 01 Nov 2010 17:34:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/7] KVM: handle more completed apfs if possible
References: <4CCE8143.3090105@cn.fujitsu.com> <4CCE822B.1070909@cn.fujitsu.com> <20101101092457.GY26191@redhat.com>
In-Reply-To: <20101101092457.GY26191@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 05:24 PM, Gleb Natapov wrote:

>> -		put_page(work->page);
>> -	kmem_cache_free(async_pf_cache, work);
>> +		list_del(&work->queue);
>> +		vcpu->async_pf.queued--;
>> +		if (work->page)
>> +			put_page(work->page);
>> +		kmem_cache_free(async_pf_cache, work);
>> +	} while (ret && !list_empty_careful(&vcpu->async_pf.done));
>>  }
>>  
> No need to change kvm_arch_async_page_present() to return anything. You
> can do while loop like this:
> 
> while (!list_empty_careful(&vcpu->async_pf.done) &&
>        kvm_arch_can_inject_async_page_present(vcpu)) {
> }
> 
> If kvm_arch_async_page_present() call injects exception
> kvm_arch_can_inject_async_page_present() will return false on next
> iteration.

Yeah, it's a better way, i'll fix it, thanks Gleb!
