Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab0J1HCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:02:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58759 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab0J1HCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:02:03 -0400
Message-ID: <4CC920F2.4080008@cn.fujitsu.com>
Date: Thu, 28 Oct 2010 15:06:26 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/8] KVM: avoid unnecessary wait for a async pf
References: <4CC7EA7D.5020901@cn.fujitsu.com> <4CC7EB3A.6070002@cn.fujitsu.com> <20101027104210.GN26191@redhat.com>
In-Reply-To: <20101027104210.GN26191@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 06:42 PM, Gleb Natapov wrote:
> On Wed, Oct 27, 2010 at 05:04:58PM +0800, Xiao Guangrong wrote:
>> In current code, it checks async pf completion out of the wait context,
>> like this:
>>
>> if (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
>> 		    !vcpu->arch.apf.halted)
>> 			r = vcpu_enter_guest(vcpu);
>> 		else {
>> 			......
>> 			kvm_vcpu_block(vcpu)
>> 			 ^- waiting until 'async_pf.done' is not empty
>> }
>> 	
>> kvm_check_async_pf_completion(vcpu)
>>  ^- delete list from async_pf.done
>>
>> So, if we check aysnc pf completion first, it can be blocked at
>> kvm_vcpu_block
>>
> Correct, but it can be fixed by adding vcpu->arch.apf.halted = false; to
> kvm_arch_async_page_present(), no?
> Adding kvm_check_async_pf_completion() to arch independent kvm_vcpu_block()
> constrains how other archs may implement async pf support IMO.
>  

Um, i think it's reasonable, will fix it address your comment.
