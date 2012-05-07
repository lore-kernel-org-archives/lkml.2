Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2EGMWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:22:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab2EGMWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:22:46 -0400
Message-ID: <4FA7BABA.4040700@redhat.com>
Date: Mon, 07 May 2012 15:06:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
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
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120507082928.GI16608@gmail.com> <4FA7888F.80505@redhat.com> <4FA7AAD8.6050003@linux.vnet.ibm.com>
In-Reply-To: <4FA7AAD8.6050003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 01:58 PM, Raghavendra K T wrote:
> On 05/07/2012 02:02 PM, Avi Kivity wrote:
>> On 05/07/2012 11:29 AM, Ingo Molnar wrote:
>>> This is looking pretty good and complete now - any objections
>>> from anyone to trying this out in a separate x86 topic tree?
>>
>> No objections, instead an
>>
>> Acked-by: Avi Kivity<avi@redhat.com>
>>
>
> Thank you.
>
> Here is a benchmark result with the patches.
>
> 3 guests with 8VCPU, 8GB RAM, 1 used for kernbench
> (kernbench -f -H -M -o 20) other for cpuhog (shell script while
> true with an instruction)
>
> unpinned scenario
> 1x: no hogs
> 2x: 8hogs in one guest
> 3x: 8hogs each in two guest
>
> BASE: 3.4-rc4 vanilla with CONFIG_PARAVIRT_SPINLOCK=n
> BASE+patch: 3.4-rc4 + debugfs + pv patches with
> CONFIG_PARAVIRT_SPINLOCK=y
>
> Machine : IBM xSeries with Intel(R) Xeon(R) x5570 2.93GHz CPU (Non
> PLE) with 8 core , 64GB RAM
>
> (Less is better. Below is time elapsed in sec for x86_64_defconfig
> (3+3 runs)).
>
>          BASE                    BASE+patch            %improvement
>          mean (sd)               mean (sd)
> case 1x:     66.0566 (74.0304)      61.3233 (68.8299)     7.16552
> case 2x:     1253.2 (1795.74)      131.606 (137.358)     89.4984
> case 3x:     3431.04 (5297.26)      134.964 (149.861)     96.0664
>

You're calculating the improvement incorrectly.  In the last case, it's
not 96%, rather it's 2400% (25x).  Similarly the second case is about
900% faster.

-- 
error compiling committee.c: too many arguments to function

