Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab0J1HzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:55:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58077 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab0J1HzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:55:21 -0400
Message-ID: <4CC92D6B.5090701@cn.fujitsu.com>
Date: Thu, 28 Oct 2010 15:59:39 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/8] KVM: simply wakup async pf
References: <4CC7EA7D.5020901@cn.fujitsu.com> <4CC7EBD4.6070105@cn.fujitsu.com> <20101027105057.GP26191@redhat.com>
In-Reply-To: <20101027105057.GP26191@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 06:50 PM, Gleb Natapov wrote:
> On Wed, Oct 27, 2010 at 05:07:32PM +0800, Xiao Guangrong wrote:
>> The current way is queued a complete async pf with:
>> 	asyc_pf.page = bad_page
>> 	async_pf.arch.gfn = 0
>>
>> It has two problems while kvm_check_async_pf_completion handle this
>> async_pf:
>> - since !async_pf.page, it can retry a pseudo #PF
> kvm_arch_async_page_ready checks for is_error_page()
> 
>> - it can delete gfn 0 from vcpu->arch.apf.gfns[]
> kvm_arch_async_page_present() checks for is_error_page() too and,
> in case of PV guest, injects special token if it is true. 
> 

Ah, sorry for my stupid questions.

> After your patch special token will not be injected and migration will
> not work.
> 
>> Actually, we can simply record this wakeup request and let
>> kvm_check_async_pf_completion simply break the wait
>>
> May be wakeup_all function naming is misleading. It means wake up all PV
> guest processes by sending broadcast async pf notification. It is not
> about waking host vcpu thread.
> 

I'm not good at the KVM PV way, i'll dig into it, please ignore this patch,
thanks.
