Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab2KZWsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:48:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:23268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353Ab2KZWsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:48:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,323,1352102400"; 
   d="scan'208";a="172849681"
Message-ID: <50B3F1D2.4010200@linux.intel.com>
Date: Mon, 26 Nov 2012 14:48:50 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Linux KVM mailing list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, kvm: Remove incorrect redundant assembly constraint
References: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com> <1353537681-18759-1-git-send-email-hpa@linux.intel.com> <50B318C5.8090508@redhat.com>
In-Reply-To: <50B318C5.8090508@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2012 11:22 PM, Paolo Bonzini wrote:
> Il 21/11/2012 23:41, H. Peter Anvin ha scritto:
>> From: "H. Peter Anvin" <hpa@linux.intel.com>
>>
>> In __emulate_1op_rax_rdx, we use "+a" and "+d" which are input/output
>> constraints, and *then* use "a" and "d" as input constraints.  This is
>> incorrect, but happens to work on some versions of gcc.
>>
>> However, it breaks gcc with -O0 and icc, and may break on future
>> versions of gcc.
>>
>> Reported-and-tested-by: Melanie Blower <melanie.blower@intel.com>
>> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>> Link: http://lkml.kernel.org/r/B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com
>> ---
>>  arch/x86/kvm/emulate.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 39171cb..bba39bf 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -426,8 +426,7 @@ static void invalidate_registers(struct x86_emulate_ctxt *ctxt)
>>  			_ASM_EXTABLE(1b, 3b)				\
>>  			: "=m" ((ctxt)->eflags), "=&r" (_tmp),		\
>>  			  "+a" (*rax), "+d" (*rdx), "+qm"(_ex)		\
>> -			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val),	\
>> -			  "a" (*rax), "d" (*rdx));			\
>> +			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val));	\
>>  	} while (0)
>>  
>>  /* instruction has only one source operand, destination is implicit (e.g. mul, div, imul, idiv) */
>>
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 

Gleb, Marcelo: are you going to apply this or would you prefer I took it
in x86/urgent?

	-hpa

