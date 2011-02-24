Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1BXKxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 05:53:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab1BXKxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 05:53:00 -0500
Message-ID: <4D663886.6080803@redhat.com>
Date: Thu, 24 Feb 2011 12:52:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <20110223234258.GA29548@nik-comp.lan> <4D663044.3080000@redhat.com> <20110224104800.GA29840@pcnci.linuxbox.cz>
In-Reply-To: <20110224104800.GA29840@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 12:48 PM, Nikola Ciprich wrote:
> On Thu, Feb 24, 2011 at 12:17:40PM +0200, Avi Kivity wrote:
> >  On 02/24/2011 01:42 AM, Nikola Ciprich wrote:
> >>  Hello Avi et al,
> >>  seems like I've hit regression in 2.6.37:
> >>  32bit SMP centos guest stopped booting, they just hang during initrd phase. (haven't tried
> >>  different distros)
> >>  UP guest are OK.
> >>  when I (forcibly) compiled kvm-kmod-2.6.36.2 and used it in 2.6.37, even
> >>  the SMP guests boot fine.
> >>  does somebody have a tip on where the problem could be, or should I bisect this?
> >>  I tried on 2 different machines, host is x86_64, qemu-kvm 0.13.0, 0.14.0.
> >>  If I shall provide more information (or bisect), please let me know.
> >
> >  Bisect is of course great, if laborious.  Meanwhile can you post 'info
> >  registers' for all cpus?  Is the guest consuming cpu?  kvm_stat output?
> yes, it's eating 100% of one CPU core.
>
> kvm_stat for few seconds (hunged guest is the only one running on the host):
>
>   kvm_entry                                    29327    9091
>   kvm_exit                                     29357    9090
>   kvm_inj_virq                                 24588    7609
>   kvm_apic_accept_irq                          17146    5310
>   kvm_emulate_insn                             12682    3931
>   kvm_apic                                     12530    3879
>   kvm_mmio                                     12525    3879
>   kvm_exit(APIC_ACCESS)                        12525    3879
>   kvm_exit(HLT)                                11262    3466
>   kvm_ioapic_set_irq                            6532    2024
>   kvm_set_irq                                   6538    2024
>   kvm_pic_set_irq                               6536    2024
>   kvm_exit(EXTERNAL_INTERRUPT)                  4255    1300
>   kvm_ack_irq                                   2442     756
>   kvm_exit(PENDING_INTERRUPT)                   1030     335
>   kvm_exit(IO_INSTRUCTION)                       313     104
>   kvm_pio                                        312     104
>   kvm_age_page                                    18	  6
>   kvm_exit(EPT_VIOLATION)                         14       4
>   kvm_page_fault                                  12	  4
>   kvm_exit(INVALID_STATE)                          4	  0
>   kvm_exit(VMLAUNCH)                               3	  0
>   kvm_exit(CPUID)                                  3	  0
>   kvm_exit(DR_ACCESS)                              2       0
>   kvm_exit(MSR_READ)                               2       0
>   kvm_exit(PAUSE_INSTRUCTION)                      1       0
>

Guest is churning along.

> info registers:
> EAX=00000000 EBX=6a000000 ECX=0000000a EDX=000f41a8
> ESI=000f41a8 EDI=00000000 EBP=c0690320 ESP=c0769f58
> EIP=c042d137 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
>

Not very useful when the guest is making progress, I'm afraid.

> I'll wait a bit with bisect whether You'll spot some obvious bug or not ;)
> thanks for Your time!

Can you try a little trace-cmd -e kvm -b 20000?

> PS: I still owe You the kvm_stat comparison about this slow windows chkdsk problem,
> I'm aware of it, I just had to postpone this due to more urgent matters :(
> but I'll get back to it sooner or later..

Sure.  Something similar that came up - sometimes Windows IDE drivers 
fall back to PIO mode.  Are you using IDE?  If so, please check whether 
it's using DMA or PIO.

-- 
error compiling committee.c: too many arguments to function

