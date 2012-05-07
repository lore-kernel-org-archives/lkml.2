Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab2EGOrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:47:53 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37984 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab2EGOrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:47:51 -0400
Message-ID: <4FA7E06E.20304@linux.vnet.ibm.com>
Date: Mon, 07 May 2012 20:17:10 +0530
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
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120507082928.GI16608@gmail.com> <4FA7888F.80505@redhat.com> <4FA7AAD8.6050003@linux.vnet.ibm.com> <4FA7BABA.4040700@redhat.com> <4FA7CC05.50808@linux.vnet.ibm.com> <4FA7CCA2.4030408@redhat.com> <4FA7D06B.60005@linux.vnet.ibm.com> <20120507134611.GB5533@linux.vnet.ibm.com> <4FA7D2E5.1020607@redhat.com> <4FA7D3F7.9080005@linux.vnet.ibm.com> <4FA7D50D.1020209@redhat.com>
In-Reply-To: <4FA7D50D.1020209@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12050704-5490-0000-0000-0000014C851D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 07:28 PM, Avi Kivity wrote:
> On 05/07/2012 04:53 PM, Raghavendra K T wrote:
>>> Is the improvement so low, because PLE is interfering with the patch, or
>>> because PLE already does a good job?
>>>
>>
>>
>> It is because PLE already does a good job (of not burning cpu). The
>> 1-3% improvement is because, patchset knows atleast who is next to hold
>> lock, which is lacking in PLE.
>>
>
> Not good.  Solving a problem in software that is already solved by
> hardware?  It's okay if there are no costs involved, but here we're
> introducing a new ABI that we'll have to maintain for a long time.
>

Hmm agree that being a step ahead of mighty hardware (and just an
improvement of 1-3%) is no good for long term (where PLE is future).

Having said that, it is hard for me to resist saying :
  bottleneck is somewhere else on PLE m/c and IMHO answer would be
combination of paravirt-spinlock + pv-flush-tb.

But I need to come up with good number to argue in favour of the claim.

PS: Nikunj had experimented that pv-flush tlb + paravirt-spinlock is a 
win on PLE where only one of them alone could not prove the benefit.

