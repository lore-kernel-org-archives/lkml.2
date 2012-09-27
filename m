Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2I0KLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:11:38 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:41795 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2I0KLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:11:36 -0400
Message-ID: <5064256E.7050003@linux.vnet.ibm.com>
Date: Thu, 27 Sep 2012 15:37:42 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>, Dor Laor <dlaor@redhat.com>
CC: Chegu Vinod <chegu_vinod@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <505C691D.4080801@hp.com> <505CA5BA.4020801@linux.vnet.ibm.com> <50601CE7.60801@redhat.com> <50604BF0.1070607@linux.vnet.ibm.com> <5061C70E.2090308@redhat.com> <20120926122725.GE7356@phenom.dumpdata.com>
In-Reply-To: <20120926122725.GE7356@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092710-5490-0000-0000-00000233D299
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 05:57 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Sep 25, 2012 at 05:00:30PM +0200, Dor Laor wrote:
>> On 09/24/2012 02:02 PM, Raghavendra K T wrote:
>>> On 09/24/2012 02:12 PM, Dor Laor wrote:
>>>> In order to help PLE and pvticketlock converge I thought that a small
>>>> test code should be developed to test this in a predictable,
>>>> deterministic way.
>>>>
>>>> The idea is to have a guest kernel module that spawn a new thread each
>>>> time you write to a /sys/.... entry.
>>>>
>>>> Each such a thread spins over a spin lock. The specific spin lock is
>>>> also chosen by the /sys/ interface. Let's say we have an array of spin
>>>> locks *10 times the amount of vcpus.
>>>>
>>>> All the threads are running a
>>>> while (1) {
>>>>
>>>> spin_lock(my_lock);
>>>> sum += execute_dummy_cpu_computation(time);
>>>> spin_unlock(my_lock);
>>>>
>>>> if (sys_tells_thread_to_die()) break;
>>>> }
>>>>
>>>> print_result(sum);
>>>>
>>>> Instead of calling the kernel's spin_lock functions, clone them and make
>>>> the ticket lock order deterministic and known (like a linear walk of all
>>>> the threads trying to catch that lock).
>>>
>>> By Cloning you mean hierarchy of the locks?
>>
>> No, I meant to clone the implementation of the current spin lock
>> code in order to set any order you may like for the ticket
>> selection.
>> (even for a non pvticket lock version)
>
> Wouldn't that defeat the purpose of trying the test the different
> implementations that try to fix the lock-holder preemption problem?
> You want something that you can shoe-in for all work-loads - also
> for this test system.

Hmm true. I think it is indeed difficult to shoe-in all workloads.

