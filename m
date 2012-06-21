Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2FUCLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:11:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757436Ab2FUCLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:11:16 -0400
Message-ID: <4FE282B5.3010606@redhat.com>
Date: Wed, 20 Jun 2012 22:11:01 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case
References: <20120619202047.26191.40429.sendpatchset@codeblue> <20120619165104.2a4574f8@annuminas.surriel.com> <4FE22E9E.7070206@linux.vnet.ibm.com>
In-Reply-To: <4FE22E9E.7070206@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 04:12 PM, Raghavendra K T wrote:
> On 06/20/2012 02:21 AM, Rik van Riel wrote:

>> Please let me know how it goes.
>
> Yes, have got result today, too tired to summarize. got better
> performance result too. will come back again tomorrow morning.
> have to post, randomized start point patch also, which I discussed to
> know the opinion.

The other person's problem has also gone away with this
patch.

Avi, could I convince you to apply this obvious bugfix
to kvm.git? :)

>> ====8<====
>>
>> If last_boosted_vcpu == 0, then we fall through all test cases and
>> may end up with all VCPUs pouncing on vcpu 0. With a large enough
>> guest, this can result in enormous runqueue lock contention, which
>> can prevent vcpu0 from running, leading to a livelock.
>>
>> Changing< to<= makes sure we properly handle that case.

>>
>> Signed-off-by: Rik van Riel<riel@redhat.com>
>> ---
>> virt/kvm/kvm_main.c | 2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 7e14068..1da542b 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1586,7 +1586,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>> */
>> for (pass = 0; pass< 2&& !yielded; pass++) {
>> kvm_for_each_vcpu(i, vcpu, kvm) {
>> - if (!pass&& i< last_boosted_vcpu) {
>> + if (!pass&& i<= last_boosted_vcpu) {
>> i = last_boosted_vcpu;
>> continue;
>> } else if (pass&& i> last_boosted_vcpu)
>>
>>
>


-- 
All rights reversed
