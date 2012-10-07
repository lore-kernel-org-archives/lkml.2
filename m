Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2JGJwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 05:52:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab2JGJv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 05:51:58 -0400
Message-ID: <507150A7.9010001@redhat.com>
Date: Sun, 07 Oct 2012 11:51:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Gleb Natapov <gleb@redhat.com>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <5061713D.5060406@redhat.com> <CAJocwcf+8u84_yDC-PK0Yni93YSTWzYvr69nq6b3pNv1MwVJzQ@mail.gmail.com> <50641356.5070008@redhat.com> <CAJocwcc19F+PtsQ5okGMvYeVnkEigpZRpwWY9JgeRPFqfcVoXA@mail.gmail.com> <506540C7.9070105@linux.vnet.ibm.com> <50680049.5020206@redhat.com> <20120930110755.GB1009@redhat.com> <50682945.3060309@redhat.com> <20121003141739.GA15253@linux.vnet.ibm.com> <506C5239.4080209@redhat.com> <20121004072900.GU23096@redhat.com> <506E9C01.5040300@linux.vnet.ibm.com>
In-Reply-To: <506E9C01.5040300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 10:36 AM, Raghavendra K T wrote:
>>>
>>> You can store i in the vcpu itself:
>>>
>>>    set_bit(vcpu->index, &kvm->preempted);
>>>
>> This will make the fact that vcpus are stored in an array into API
>> instead of implementation detail :( There were patches for vcpu
>> destruction that changed the array to rculist. Well, it will be still
>> possible to make the array rcu protected and copy it every time vcpu is
>> deleted/added I guess.
>>
> 
> If IUC, summary is, we are going with
> - Let vcpu array be rcu protected.

That's for the future.  For now ->vcpus[] is statically allocated.

> - we use index inside vcpu and should be updated when a vcpu is
> added/deleted.

Yes.


-- 
error compiling committee.c: too many arguments to function
