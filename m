Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1KUBOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 20:14:43 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:58675 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab1KUBOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 20:14:40 -0500
X-Greylist: delayed 1255 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Nov 2011 20:14:40 EST
Message-ID: <4EC9A136.7080004@oss.ntt.co.jp>
Date: Mon, 21 Nov 2011 09:54:14 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] KVM: introduce kvm_for_each_memslot macro
References: <4EC6226B.3080408@linux.vnet.ibm.com> <4EC622F8.30005@linux.vnet.ibm.com> <4EC8E2D3.1080804@redhat.com>
In-Reply-To: <4EC8E2D3.1080804@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/11/20 20:21), Avi Kivity wrote:
> On 11/18/2011 11:18 AM, Xiao Guangrong wrote:
>> index bb8728e..10524c0 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -307,6 +307,10 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
>>   	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
>>   	     idx++)
>>
>> +#define kvm_for_each_memslot(slots, memslot, i)	\
>> +	for (i = 0; i<  (slots)->nmemslots&&	\
>> +	      ({ memslot =&(slots)->memslots[i]; 1; }); i++)
>> +
>>
>
> Statement expression not needed, you can use the comma operator:
>
>    i<  (slots)->nmemslots&&  (memslot = @(slots)->memslots[i], true)
>
> or even
>
>    memslot =&(slots)->memslots[i], i<  (slots)->nmemslots
>
> or just kill i and make memslot the loop variable.
>

Do you have any preference for the arguments ordering?

I think placing the target one, memslot in this case, first is conventional in
the kernel code, except when we want to place "kvm" or something like that.

But in kvm code, there seems to be some difference.

	Takuya
