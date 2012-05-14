Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2ENINb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:13:31 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45594 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab2ENIN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:13:28 -0400
Message-ID: <4FB0BE4A.6060604@linux.vnet.ibm.com>
Date: Mon, 14 May 2012 13:41:54 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Avi Kivity <avi@redhat.com>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Attilio Rao <attilio.rao@citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, linux-doc@vger.kernel.org,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V8 0/17] Paravirtualized ticket spinlocks
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120507082928.GI16608@gmail.com> <4FA7888F.80505@redhat.com> <4FA7AAD8.6050003@linux.vnet.ibm.com> <4FA7BABA.4040700@redhat.com> <4FA7CC05.50808@linux.vnet.ibm.com> <4FA7CCA2.4030408@redhat.com> <4FA7D06B.60005@linux.vnet.ibm.com> <20120507134611.GB5533@linux.vnet.ibm.com> <4FA7D2E5.1020607@redhat.com> <4FA7D3F7.9080005@linux.vnet.ibm.com> <4FA7D50D.1020209@redhat.com> <4FA7E06E.20304@linux.vnet.ibm.com> <4FA7E1C8.7010509@redhat.com> <4FB0014A.90604@linux.vnet.ibm.com> <4FB0B679.1020600@goop.org>
In-Reply-To: <4FB0B679.1020600@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12051408-5816-0000-0000-00000298FFBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 01:08 PM, Jeremy Fitzhardinge wrote:
> On 05/13/2012 11:45 AM, Raghavendra K T wrote:
>> On 05/07/2012 08:22 PM, Avi Kivity wrote:
>>
>> I could not come with pv-flush results (also Nikunj had clarified that
>> the result was on NOn PLE
>>
>>> I'd like to see those numbers, then.
>>>
>>> Ingo, please hold on the kvm-specific patches, meanwhile.
>>>
>>
>> 3 guests 8GB RAM, 1 used for kernbench
>> (kernbench -f -H -M -o 20) other for cpuhog (shell script with  while
>> true do hackbench)
>>
>> 1x: no hogs
>> 2x: 8hogs in one guest
>> 3x: 8hogs each in two guest
>>
>> kernbench on PLE:
>> Machine : IBM xSeries with Intel(R) Xeon(R)  X7560 2.27GHz CPU with 32
>> core, with 8 online cpus and 4*64GB RAM.
>>
>> The average is taken over 4 iterations with 3 run each (4*3=12). and
>> stdev is calculated over mean reported in each run.
>>
>>
>> A): 8 vcpu guest
>>
>>                   BASE                    BASE+patch %improvement w.r.t
>>                   mean (sd)               mean (sd)
>> patched kernel time
>> case 1*1x:    61.7075  (1.17872)    60.93     (1.475625)    1.27605
>> case 1*2x:    107.2125 (1.3821349)    97.506675 (1.3461878)   9.95401
>> case 1*3x:    144.3515 (1.8203927)    138.9525  (0.58309319)  3.8855
>>
>>
>> B): 16 vcpu guest
>>                   BASE                    BASE+patch %improvement w.r.t
>>                   mean (sd)               mean (sd)
>> patched kernel time
>> case 2*1x:    70.524   (1.5941395)    69.68866  (1.9392529)   1.19867
>> case 2*2x:    133.0738 (1.4558653)    124.8568  (1.4544986)   6.58114
>> case 2*3x:    206.0094 (1.3437359)    181.4712  (2.9134116)   13.5218
>>
>> B): 32 vcpu guest
>>                   BASE                    BASE+patch %improvementw.r.t
>>                   mean (sd)               mean (sd)
>> patched kernel time
>> case 4*1x:    100.61046 (2.7603485)     85.48734  (2.6035035)  17.6905
>
> What does the "4*1x" notation mean? Do these workloads have overcommit
> of the PCPU resources?
>
> When I measured it, even quite small amounts of overcommit lead to large
> performance drops with non-pv ticket locks (on the order of 10%
> improvements when there were 5 busy VCPUs on a 4 cpu system).  I never
> tested it on larger machines, but I guess that represents around 25%
> overcommit, or 40 busy VCPUs on a 32-PCPU system.

All the above measurements are on PLE machine. It is 32 vcpu single
guest on a 8 pcpu.

(PS:One problem I saw in my kernbench run itself is that
number of threads spawned = 20 instead of 2* number of vcpu. I ll
correct during next measurement.)

"even quite small amounts of overcommit lead to large performance drops
with non-pv ticket locks":

This is very much true on non PLE machine. probably compilation takes
even a day vs just one hour. ( with just 1:3x overcommit I had got 25 x
speedup).

