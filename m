Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650Ab0EEPEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:04:11 -0400
Received: from 8bytes.org ([88.198.83.132]:60189 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab0EEPEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:04:09 -0400
Date: Wed, 5 May 2010 17:04:06 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: SVM: Allow EFER.LMSLE to be set with nested
	svm
Message-ID: <20100505150406.GF14542@8bytes.org>
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com> <1273068285-3105-5-git-send-email-joerg.roedel@amd.com> <4BE184E3.1010508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE184E3.1010508@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 05:46:59PM +0300, Avi Kivity wrote:
> On 05/05/2010 05:04 PM, Joerg Roedel wrote:
>> This patch enables setting of efer bit 13 which is allowed
>> in all SVM capable processors. This is necessary for the
>> SLES11 version of Xen 4.0 to boot with nested svm.
>>    
>
> Interesting, why does it require it?

I don't know. I traced the Xen crash down and found that is gets a #GP
because it tries to set this bit.

> Obviously it isn't needed since it manages to run on Intel without it.

I have heard inofficial statements that they set this bit to provide the
functionality to their guests. And Xen sets this bit together with the
SVM bit.

>>   /* Intel MSRs. Some also available on other CPUs */
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 74f7b9d..bc087c7 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -610,7 +610,7 @@ static __init int svm_hardware_setup(void)
>>
>>   	if (nested) {
>>   		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
>> -		kvm_enable_efer_bits(EFER_SVME);
>> +		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>>   	}
>>
>>   	for_each_possible_cpu(cpu) {
>>    
>
> What if the host doesn't have it?

It is present in all SVM capable AMD processors.

> Why enable it only for the nested case?  It's not svm specific (it's  
> useful for running non-hvm Xen in non-nested mode).

Because there is no cpuid bit for this feature. You can roughly check
for it using the svm cpuid bit.


	Joerg

