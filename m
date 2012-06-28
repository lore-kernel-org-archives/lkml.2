Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2F1LLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:11:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab2F1LLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:11:34 -0400
Message-ID: <4FEC3BE3.8050802@redhat.com>
Date: Thu, 28 Jun 2012 07:11:31 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] kvm, Add x86_hyper_kvm to complete detect_hypervisor_platform
 check
References: <1340833338-15485-1-git-send-email-prarit@redhat.com> <20120628012419.GA8956@phenom.dumpdata.com>
In-Reply-To: <20120628012419.GA8956@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/27/2012 09:24 PM, Konrad Rzeszutek Wilk wrote:
> On Wed, Jun 27, 2012 at 05:42:18PM -0400, Prarit Bhargava wrote:
>> While debugging I noticed that unlike all the other hypervisor code in the
>> kernel, kvm does not have an entry for x86_hyper which is used in
>> detect_hypervisor_platform(), and results in a nice message about the
>> hypervisor being used.  This is only really a stub function and it makes
>> kvm more consistent with the other hypervisors (and it makes debugging
>> a little easier).
>>
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>> Cc: Avi Kivity <avi@redhat.com>
>> Cc: Gleb Natapov <gleb@redhat.com>
>> Cc: Alex Williamson <alex.williamson@redhat.com>
>> ---
>>  arch/x86/include/asm/hypervisor.h |    1 +
>>  arch/x86/kernel/cpu/hypervisor.c  |    1 +
>>  arch/x86/kernel/kvm.c             |    6 ++++++
>>  3 files changed, 8 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
>> index 7a15153..b518c75 100644
>> --- a/arch/x86/include/asm/hypervisor.h
>> +++ b/arch/x86/include/asm/hypervisor.h
>> @@ -49,6 +49,7 @@ extern const struct hypervisor_x86 *x86_hyper;
>>  extern const struct hypervisor_x86 x86_hyper_vmware;
>>  extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
>>  extern const struct hypervisor_x86 x86_hyper_xen_hvm;
>> +extern const struct hypervisor_x86 x86_hyper_kvm;
>>  
>>  static inline bool hypervisor_x2apic_available(void)
>>  {
>> diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
>> index 755f64f..6d6dd7a 100644
>> --- a/arch/x86/kernel/cpu/hypervisor.c
>> +++ b/arch/x86/kernel/cpu/hypervisor.c
>> @@ -37,6 +37,7 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
>>  #endif
>>  	&x86_hyper_vmware,
>>  	&x86_hyper_ms_hyperv,
>> +	&x86_hyper_kvm,
>>  };
>>  
>>  const struct hypervisor_x86 *x86_hyper;
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index e554e5a..0a38b68 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -39,6 +39,7 @@
>>  #include <asm/desc.h>
>>  #include <asm/tlbflush.h>
>>  #include <asm/idle.h>
>> +#include <asm/hypervisor.h>
>>  
>>  static int kvmapf = 1;
>>  
>> @@ -432,6 +433,11 @@ void __init kvm_guest_init(void)
>>  #endif
>>  }
>>  
>> +const struct hypervisor_x86 x86_hyper_kvm __refconst = {
>> +	.name			= "KVM",
>> +};
>> +EXPORT_SYMBOL(x86_hyper_kvm);
> 
> EXPORT_SYMBOL_GPL version. ?

Hey Konrad, thanks for the review.

The other hypervisor_x86 structs are only EXPORT_SYMBOL, so I maintained that
convention here.

If I'm mistaken in that assumption, please let me know.

Thanks again,

P.
