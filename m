Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2EHF0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 01:26:46 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:37345 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2EHF0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 01:26:45 -0400
Message-ID: <4FA8AE38.9050109@linux.vnet.ibm.com>
Date: Tue, 08 May 2012 10:55:12 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
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
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V8 0/17] Paravirtualized ticket spinlocks
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120507082928.GI16608@gmail.com> <4FA7888F.80505@redhat.com> <4FA7AAD8.6050003@linux.vnet.ibm.com> <4FA7BABA.4040700@redhat.com> <4FA7CC05.50808@linux.vnet.ibm.com> <4FA7CCA2.4030408@redhat.com> <4FA7D06B.60005@linux.vnet.ibm.com> <20120507134611.GB5533@linux.vnet.ibm.com> <4FA7D2E5.1020607@redhat.com> <4FA7D3F7.9080005@linux.vnet.ibm.com> <4FA7D50D.1020209@redhat.com> <4FA7E06E.20304@linux.vnet.ibm.com> <4FA7E1C8.7010509@redhat.com>
In-Reply-To: <4FA7E1C8.7010509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12050719-1396-0000-0000-0000011C67AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 08:22 PM, Avi Kivity wrote:
> On 05/07/2012 05:47 PM, Raghavendra K T wrote:
>>> Not good.  Solving a problem in software that is already solved by
>>> hardware?  It's okay if there are no costs involved, but here we're
>>> introducing a new ABI that we'll have to maintain for a long time.
>>>
>>
>>
>> Hmm agree that being a step ahead of mighty hardware (and just an
>> improvement of 1-3%) is no good for long term (where PLE is future).
>>
>
> PLE is the present, not the future.  It was introduced on later Nehalems
> and is present on all Westmeres.  Two more processor generations have
> passed meanwhile.  The AMD equivalent was also introduced around that
> timeframe.
>
>> Having said that, it is hard for me to resist saying :
>>   bottleneck is somewhere else on PLE m/c and IMHO answer would be
>> combination of paravirt-spinlock + pv-flush-tb.
>>
>> But I need to come up with good number to argue in favour of the claim.
>>
>> PS: Nikunj had experimented that pv-flush tlb + paravirt-spinlock is a
>> win on PLE where only one of them alone could not prove the benefit.
>>
>
> I'd like to see those numbers, then.
>
> Ingo, please hold on the kvm-specific patches, meanwhile.
>


Hmm. I think I messed up the fact while saying 1-3% improvement on PLE.

Going by what I had posted in  https://lkml.org/lkml/2012/4/5/73 (with
correct calculation)

   1x  	 70.475 (85.6979) 	63.5033 (72.7041)   15.7%
   2x  	 110.971 (132.829) 	105.099 (128.738)    5.56%	
   3x   	 150.265 (184.766) 	138.341 (172.69)     8.62%


It was around 12% with optimization patch posted separately with that 
(That one Needs more experiment though)

But anyways, I will come up with result for current patch series..

