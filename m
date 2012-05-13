Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab2EMSAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:00:21 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37341 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab2EMSAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 14:00:19 -0400
Message-ID: <4FAFF680.6030307@linux.vnet.ibm.com>
Date: Sun, 13 May 2012 23:29:28 +0530
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
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120507082928.GI16608@gmail.com> <4FA7888F.80505@redhat.com> <4FA7AAD8.6050003@linux.vnet.ibm.com> <4FA7BABA.4040700@redhat.com>
In-Reply-To: <4FA7BABA.4040700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12051307-5140-0000-0000-0000014E561A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 05:36 PM, Avi Kivity wrote:
> On 05/07/2012 01:58 PM, Raghavendra K T wrote:
>> On 05/07/2012 02:02 PM, Avi Kivity wrote:
>>> On 05/07/2012 11:29 AM, Ingo Molnar wrote:
>> (Less is better. Below is time elapsed in sec for x86_64_defconfig
>> (3+3 runs)).
>>
>>           BASE                    BASE+patch            %improvement
>>           mean (sd)               mean (sd)
>> case 1x:     66.0566 (74.0304)      61.3233 (68.8299)     7.16552
>> case 2x:     1253.2 (1795.74)      131.606 (137.358)     89.4984
>> case 3x:     3431.04 (5297.26)      134.964 (149.861)     96.0664
>>
>
> You're calculating the improvement incorrectly.  In the last case, it's
> not 96%, rather it's 2400% (25x).  Similarly the second case is about
> 900% faster.
>

speedup calculation is clear.

I think confusion for me was more because of the types of benchmarks.

I always did

|(patch - base)| * 100 / base


So,  for
(1) lesser is better sort of benchmarks,
improvement calculation would be like

|(patched -  base)| * 100/ patched
e.g for kernbench,

suppose base    = 150 sec
         patched = 100 sec
improvement = 50 % ( = 33% degradation of base)


(2) for higher is better sort of benchmarks improvement calculation 
would be like

|(patched - base)| * 100 / base

for e.g say for pgbench/ ebizzy...

     base = 100 tps (transactions per sec)
     patched = 150 tps

  improvement  = 50 % of pathched kernel ( OR 33 % degradation of base )


Is this is what generally done? just wanted to be on same page before 
publishing benchmark results, other than kernbench.

