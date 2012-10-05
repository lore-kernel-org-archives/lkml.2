Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab2JEJLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:11:03 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33361 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab2JEJLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:11:01 -0400
Message-ID: <506EA323.7000300@linux.vnet.ibm.com>
Date: Fri, 05 Oct 2012 14:36:43 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: habanero@linux.vnet.ibm.com
CC: Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <20121003122209.GA9076@linux.vnet.ibm.com> <506C7057.6000102@redhat.com> <506D69AB.7020400@linux.vnet.ibm.com> <506D83EE.2020303@redhat.com> <1349361663.5551.56.camel@oc6622382223.ibm.com>
In-Reply-To: <1349361663.5551.56.camel@oc6622382223.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12100509-7014-0000-0000-000001FC924F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 08:11 PM, Andrew Theurer wrote:
> On Thu, 2012-10-04 at 14:41 +0200, Avi Kivity wrote:
>> On 10/04/2012 12:49 PM, Raghavendra K T wrote:
>>> On 10/03/2012 10:35 PM, Avi Kivity wrote:
>>>> On 10/03/2012 02:22 PM, Raghavendra K T wrote:
>>>>>> So I think it's worth trying again with ple_window of 20000-40000.
>>>>>>
>>>>>
>>>>> Hi Avi,
>>>>>
>>>>> I ran different benchmarks increasing ple_window, and results does not
>>>>> seem to be encouraging for increasing ple_window.
>>>>
>>>> Thanks for testing! Comments below.
>>>>
>>>>> Results:
>>>>> 16 core PLE machine with 16 vcpu guest.
>>>>>
>>>>> base kernel = 3.6-rc5 + ple handler optimization patch
>>>>> base_pleopt_8k = base kernel + ple window = 8k
>>>>> base_pleopt_16k = base kernel + ple window = 16k
>>>>> base_pleopt_32k = base kernel + ple window = 32k
>>>>>
>>>>>
>>>>> Percentage improvements of benchmarks w.r.t base_pleopt with
>>>>> ple_window = 4096
>>>>>
>>>>>          base_pleopt_8k    base_pleopt_16k    base_pleopt_32k
>>>>> -----------------------------------------------------------------
>>>>>
>>>>> kernbench_1x    -5.54915    -15.94529    -44.31562
>>>>> kernbench_2x    -7.89399    -17.75039    -37.73498
>>>>
>>>> So, 44% degradation even with no overcommit?  That's surprising.
>>>
>>> Yes. Kernbench was run with #threads = #vcpu * 2 as usual. Is it
>>> spending 8 times the original ple_window cycles for 16 vcpus
>>> significant?
>>
>> A PLE exit when not overcommitted cannot do any good, it is better to
>> spin in the guest rather that look for candidates on the host.  In fact
>> when we benchmark we often disable PLE completely.
>
> Agreed.  However, I really do not understand why the kernbench regressed
> with bigger ple_window.  It should stay the same or improve.  Raghu, do
> you have perf data for the kernbench runs?

Andrew, No. 'll get this with perf kvm.


