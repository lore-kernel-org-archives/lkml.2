Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2EGNjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:39:25 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36995 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab2EGNjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:39:23 -0400
Message-ID: <4FA7D06B.60005@linux.vnet.ibm.com>
Date: Mon, 07 May 2012 19:08:51 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, linux-doc@vger.kernel.org,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V8 0/17] Paravirtualized ticket spinlocks
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120507082928.GI16608@gmail.com> <4FA7888F.80505@redhat.com> <4FA7AAD8.6050003@linux.vnet.ibm.com> <4FA7BABA.4040700@redhat.com> <4FA7CC05.50808@linux.vnet.ibm.com> <4FA7CCA2.4030408@redhat.com>
In-Reply-To: <4FA7CCA2.4030408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12050713-5816-0000-0000-00000276C61E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 06:52 PM, Avi Kivity wrote:
> On 05/07/2012 04:20 PM, Raghavendra K T wrote:
>> On 05/07/2012 05:36 PM, Avi Kivity wrote:
>>> On 05/07/2012 01:58 PM, Raghavendra K T wrote:
>>>> On 05/07/2012 02:02 PM, Avi Kivity wrote:
>>>>> On 05/07/2012 11:29 AM, Ingo Molnar wrote:
>>>>>> This is looking pretty good and complete now - any objections
>>>>>> from anyone to trying this out in a separate x86 topic tree?
>>>>>
>>>>> No objections, instead an
>>>>>
>>>>> Acked-by: Avi Kivity<avi@redhat.com>
>>>>>
>> [...]
>>>>
>>>> (Less is better. Below is time elapsed in sec for x86_64_defconfig
>>>> (3+3 runs)).
>>>>
>>>>            BASE                    BASE+patch            %improvement
>>>>            mean (sd)               mean (sd)
>>>> case 1x:     66.0566 (74.0304)      61.3233 (68.8299)     7.16552
>>>> case 2x:     1253.2 (1795.74)      131.606 (137.358)     89.4984
>>>> case 3x:     3431.04 (5297.26)      134.964 (149.861)     96.0664
>>>>
>>>
>>> You're calculating the improvement incorrectly.  In the last case, it's
>>> not 96%, rather it's 2400% (25x).  Similarly the second case is about
>>> 900% faster.
>>>
>>
>> You are right,
>> my %improvement was intended to be like
>> if
>> 1) base takes 100 sec ==>  patch takes 93 sec
>> 2) base takes 100 sec ==>  patch takes 11 sec
>> 3) base takes 100 sec ==>  patch takes 4 sec
>>
>> The above is more confusing (and incorrect!).
>>
>> Better is what you told which boils to 10x and 25x improvement in case
>> 2 and case 3. And IMO, this *really* gives the feeling of magnitude of
>> improvement with patches.
>>
>> I ll change script to report that way :).
>>
>
> btw, this is on non-PLE hardware, right?  What are the numbers for PLE?
>
Sure.
I 'll get hold of a PLE mc  and come up with the numbers soon. but I
'll expect the improvement around 1-3% as it was in last version.

