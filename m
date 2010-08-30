Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0H3ByP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 21:54:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58040 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab0H3ByO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 21:54:14 -0400
Message-ID: <4C7B1043.7060306@cn.fujitsu.com>
Date: Mon, 30 Aug 2010 09:58:27 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] KVM: MMU: support disable/enable mmu audit dynamicly
References: <4C78FA00.8090606@cn.fujitsu.com> <4C78FA5B.8070008@cn.fujitsu.com> <4C7A256E.3090307@redhat.com>
In-Reply-To: <4C7A256E.3090307@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2010 05:16 PM, Avi Kivity wrote:
>  On 08/28/2010 03:00 PM, Xiao Guangrong wrote:
>> Add the debugfs file named 'mmu-debug', we can disable/enable mmu
>> audit by
>> this file:
>>
>> enable:
>> echo 1>  debugfs/kvm/mmu-debug
>>
>> disable:
>> echo 0>  debugfs/kvm/mmu-debug
> 
> 
> Better as a runtime rw module parameter perhaps?  At least it avoids the
> large debugfs callbacks.
> 

Yeah, it's a good idea.

> Also, call it audit to preserve the name.

OK

>> +
>> +TRACE_EVENT(
>> +    kvm_mmu_audit,
>> +    TP_PROTO(struct kvm_vcpu *vcpu, const char *msg),
>> +    TP_ARGS(vcpu, msg),
>> +
>> +    TP_STRUCT__entry(
>> +        __field(struct kvm_vcpu *, vcpu)
>> +        __field(const char *, msg)
>> +    ),
> 
> enum instead of char *, maybe something in userspace can make use of this.
> 

OK

>> +
>> +    TP_fast_assign(
>> +        __entry->vcpu = vcpu;
>> +        __entry->msg = msg;
>> +    ),
>> +
>> +    TP_printk("%s", __entry->msg)
> 
> Here, of course, you can use print_symbolic() to preserve readability.

OK

Will fix them in the next version. 

