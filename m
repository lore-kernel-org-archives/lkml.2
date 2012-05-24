Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab2EXHT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 03:19:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab2EXHT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 03:19:27 -0400
Message-ID: <4FBDE0FB.3040100@redhat.com>
Date: Thu, 24 May 2012 10:19:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 0/9] KVM: fast page fault
References: <4FBCA4FB.8050501@linux.vnet.ibm.com> <4FBCCC09.3020605@redhat.com> <4FBDD5CA.9020906@linux.vnet.ibm.com>
In-Reply-To: <4FBDD5CA.9020906@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 09:31 AM, Xiao Guangrong wrote:
> On 05/23/2012 07:37 PM, Avi Kivity wrote:
> 
>> On 05/23/2012 11:51 AM, Xiao Guangrong wrote:
>>> Changlog:
>>> This are some changes from Marcelo's review:
>>> - drop SPTE_WRITE_PROTECT bit, now, only one bit is needed to do
>>>   lockless update.
>>>
>>> - always atomicly update spte if it can be updated out of mmu-lock.
>>>
>>> - flod the judgement of tlb flush into mmu_spte_update(), make the
>>>   code easilyer audited.
>>>
>>> Performance result:
>>> - autoest migration test (smp2.Fedora.16.64.migrate.with_autotest.dbench.unix):
>>>                                                    before     after
>>> smp2.Fedora.16.64.migrate.unix                        93      91    +2.1%
>>> smp2.Fedora.16.64.migrate.with_autotest.dbench.unix   218     188   +13.7%
>>>
>>> - the benchmark attached is used to measure the resuming time
>>>   after dirty-log
>>>                             before            after
>>> Run 10 times, Avg time:   512466818 ns.      269231261 ns   +47.5%
>> 
>> Still scary (esp. indirect sptes), but looks pretty good.
> 
> 
> Hmm, i do not have a better way to solve the ABA problem on indirect spte now. :(
> How about only allow fast page fault to work for direct spte?
> 

I'll certainly be more comfortable with that, at least to start with.

-- 
error compiling committee.c: too many arguments to function
