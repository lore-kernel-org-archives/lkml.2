Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2IRI02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:26:28 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52924 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab2IRI0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:26:25 -0400
Message-ID: <50583027.3070502@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2012 16:26:15 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: introduce FNAME(prefetch_gpte)
References: <5052FF61.3070600@linux.vnet.ibm.com> <5053000E.3050303@linux.vnet.ibm.com> <50530337.2080208@linux.vnet.ibm.com> <20120915153106.GC3037@amt.cnet>
In-Reply-To: <20120915153106.GC3037@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091808-7014-0000-0000-000001E93629
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2012 11:31 PM, Marcelo Tosatti wrote:
> On Fri, Sep 14, 2012 at 06:13:11PM +0800, Xiao Guangrong wrote:
>> On 09/14/2012 05:59 PM, Xiao Guangrong wrote:
>>
>>> +		return FNAME(prefetch_gpte)(vcpu, sp, spte, gptep[i], true);
>>
>> Sorry, this was wrong. Update this patch.
>>
>> [PATCH v2 5/5] KVM: MMU: introduce FNAME(prefetch_gpte)
>>
>> The only different thing between FNAME(update_pte) and FNAME(pte_prefetch)
>> is that the former is allowed to prefetch gfn from dirty logged slot, so
>> introduce a common function to prefetch spte
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> IMHO, for the human reader, the meaning of the two functions is
> different and therefore separation is justified. Moreover they already

Actually, these two functions do the same things, both of them prefetch
spte based on gpte. The only different is, in the case of update_pte, we
have high opportunity that the spte can be accessed soon (that why it is
allowed to prefetch dirty logged gfn).

> share common code via FNAME(prefetch_invalid_gpte) (which BTW, is a
> confusing name because the function does not prefetch gpte, it validates
> gpte).

I think it is not too bad for it not just validates gpte, it also can drop
spte if the gpte is invalid, it is also the behaviour that modify spte based
on gpte. ;)

