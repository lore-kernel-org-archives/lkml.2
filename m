Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498Ab2C3DwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 23:52:13 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47046 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006Ab2C3DwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 23:52:07 -0400
Message-ID: <4F752DB0.6060309@linux.vnet.ibm.com>
Date: Fri, 30 Mar 2012 11:51:12 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/13] KVM: MMU: split FNAME(prefetch_invalid_gpte)
References: <4F742951.7080003@linux.vnet.ibm.com> <4F7429C7.9030307@linux.vnet.ibm.com> <4F745CFE.4070703@redhat.com>
In-Reply-To: <4F745CFE.4070703@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032917-6102-0000-0000-00000123A06E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 09:00 PM, Avi Kivity wrote:

> On 03/29/2012 11:22 AM, Xiao Guangrong wrote:
>> Split FNAME(prefetch_invalid_gpte) to check gpte independently which will
>> be used in the later patch
>>
>>
>> -static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
>> -				    struct kvm_mmu_page *sp, u64 *spte,
>> -				    pt_element_t gpte)
>> +static bool FNAME(invalid_gpte)(struct kvm_vcpu *vcpu, pt_element_t gpte)
>>  {
>>  	if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
>> -		goto no_present;
>> +		return true;
>>
>>  	if (!is_present_gpte(gpte))
>> -		goto no_present;
>> +		return true;
>>
>>  	if (!(gpte & PT_ACCESSED_MASK))
>> -		goto no_present;
>> +		return true;
>>
>>  	return false;
> 
> A comment (or a name change) is needed to indicate that we're not
> checking for an invalid gpte, just invalid for caching in an spte.


Yes, i will change the name to FNAME(is_cacheable_gpte) and and some
comments.

