Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2I0MHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab2I0MHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:07:10 -0400
Message-ID: <50644148.5090201@redhat.com>
Date: Thu, 27 Sep 2012 14:06:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Jiannan Ouyang <ouyang@cs.pitt.edu>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <5060851E.1030404@redhat.com> <506166B4.4010207@linux.vnet.ibm.com> <5061713D.5060406@redhat.com> <CAJocwcf+8u84_yDC-PK0Yni93YSTWzYvr69nq6b3pNv1MwVJzQ@mail.gmail.com> <50641356.5070008@redhat.com> <50643802.5050200@linux.vnet.ibm.com>
In-Reply-To: <50643802.5050200@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 01:26 PM, Raghavendra K T wrote:
> On 09/27/2012 02:20 PM, Avi Kivity wrote:
>> On 09/25/2012 04:43 PM, Jiannan Ouyang wrote:
>>> I've actually implemented this preempted_bitmap idea.
>>
>> Interesting, please share the code if you can.
>>
>>> However, I'm doing this to expose this information to the guest, so the
>>> guest is able to know if the lock holder is preempted or not before
>>> spining. Right now, I'm doing experiment to show that this idea works.
>>>
>>> I'm wondering what do you guys think of the relationship between the
>>> pv_ticketlock approach and PLE handler approach. Are we going to adopt
>>> PLE instead of the pv ticketlock, and why?
>>
>> Right now we're searching for the best solution.  The tradeoffs are more
>> or less:
>>
>> PLE:
>> - works for unmodified / non-Linux guests
>> - works for all types of spins (e.g. smp_call_function*())
>> - utilizes an existing hardware interface (PAUSE instruction) so likely
>> more robust compared to a software interface
>>
>> PV:
>> - has more information, so it can perform better
> 
> Should we also consider that we always have an edge here for non-PLE
> machine?

True.  The deployment share for these is decreasing rapidly though.  I
hate optimizing for obsolete hardware.


-- 
error compiling committee.c: too many arguments to function
