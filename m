Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2FSCYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:24:31 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50983 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2FSCY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:24:29 -0400
Message-ID: <4FDFE2D6.1010706@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 10:24:22 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] KVM: introduce gfn_to_hva_read/kvm_read_hva/kvm_read_hva_atomic
References: <4FD6ADA6.40008@linux.vnet.ibm.com> <4FD6AE1B.7080501@linux.vnet.ibm.com> <4FDF0005.3050300@redhat.com>
In-Reply-To: <4FDF0005.3050300@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061816-0260-0000-0000-0000015CA1AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 06:16 PM, Avi Kivity wrote:

> On 06/12/2012 05:48 AM, Xiao Guangrong wrote:
>> This set of functions is only used to read data from host space, read is
>> a special case in the later patch
>>
>>
>> +/*
>> + * The hva returned by this function is only allowed to be read.
>> + * It should pair with kvm_read_hva() or kvm_read_hva_atomic().
>> + */
>> +static unsigned long gfn_to_hva_read(struct kvm *kvm, gfn_t gfn)
>> +{
>> +	return gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL);
>> +}
>> +
>> +static int kvm_read_hva(void *data, void *hva, int len)
>> +{
>> +	return __copy_from_user(data, (void __user *)hva, len);
>> +
>> +}
>> +
>> +static int kvm_read_hva_atomic(void *data, void *hva, int len)
>> +{
>> +	return __copy_from_user_inatomic(data, (void __user *)hva, len);
>> +
>> +}
> 
> Why cast to __user?  Make it __user in the first place.
> 


Okay.

> Also these are just simple wrappers, why to them at all?


For gfn_to_hva_read(), they will call gfn_to_hva_many(...write = false)
in the later patch.

For kvm_read_hva() and kvm_read_hva_atomic(), they are pure wrappers,
i think its name is a good hint to let gfn_to_hva_read to pair with
kvm_read_hva()/kvm_read_hva_atomic().

