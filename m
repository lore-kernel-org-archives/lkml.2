Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1BXKtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 05:49:10 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:34473 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab1BXKtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 05:49:08 -0500
Date: Thu, 24 Feb 2011 11:48:00 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Avi Kivity <avi@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110224104800.GA29840@pcnci.linuxbox.cz>
References: <20110223234258.GA29548@nik-comp.lan> <4D663044.3080000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D663044.3080000@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4631468 records (last update: 20110224)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 12:17:40PM +0200, Avi Kivity wrote:
> On 02/24/2011 01:42 AM, Nikola Ciprich wrote:
>> Hello Avi et al,
>> seems like I've hit regression in 2.6.37:
>> 32bit SMP centos guest stopped booting, they just hang during initrd phase. (haven't tried
>> different distros)
>> UP guest are OK.
>> when I (forcibly) compiled kvm-kmod-2.6.36.2 and used it in 2.6.37, even
>> the SMP guests boot fine.
>> does somebody have a tip on where the problem could be, or should I bisect this?
>> I tried on 2 different machines, host is x86_64, qemu-kvm 0.13.0, 0.14.0.
>> If I shall provide more information (or bisect), please let me know.
>
> Bisect is of course great, if laborious.  Meanwhile can you post 'info  
> registers' for all cpus?  Is the guest consuming cpu?  kvm_stat output?
yes, it's eating 100% of one CPU core.

kvm_stat for few seconds (hunged guest is the only one running on the host):

 kvm_entry                                    29327    9091
 kvm_exit                                     29357    9090
 kvm_inj_virq                                 24588    7609
 kvm_apic_accept_irq                          17146    5310
 kvm_emulate_insn                             12682    3931
 kvm_apic                                     12530    3879
 kvm_mmio                                     12525    3879
 kvm_exit(APIC_ACCESS)                        12525    3879
 kvm_exit(HLT)                                11262    3466
 kvm_ioapic_set_irq                            6532    2024
 kvm_set_irq                                   6538    2024
 kvm_pic_set_irq                               6536    2024
 kvm_exit(EXTERNAL_INTERRUPT)                  4255    1300
 kvm_ack_irq                                   2442     756
 kvm_exit(PENDING_INTERRUPT)                   1030     335
 kvm_exit(IO_INSTRUCTION)                       313     104
 kvm_pio                                        312     104
 kvm_age_page                                    18	  6
 kvm_exit(EPT_VIOLATION)                         14       4
 kvm_page_fault                                  12	  4
 kvm_exit(INVALID_STATE)                          4	  0
 kvm_exit(VMLAUNCH)                               3	  0
 kvm_exit(CPUID)                                  3	  0
 kvm_exit(DR_ACCESS)                              2       0
 kvm_exit(MSR_READ)                               2       0
 kvm_exit(PAUSE_INSTRUCTION)                      1       0

info registers:
EAX=00000000 EBX=6a000000 ECX=0000000a EDX=000f41a8
ESI=000f41a8 EDI=00000000 EBP=c0690320 ESP=c0769f58
EIP=c042d137 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =007b 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
CS =0060 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
SS =0068 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =007b 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
FS =0000 00000000 ffffffff 00000000
GS =0000 00000000 ffffffff 00000000
LDT=0088 c0747020 00000027 00008200 DPL=0 LDT
TR =0080 c300f380 00002073 00008b00 DPL=0 TSS32-busy
GDT=     c302b000 000000ff
IDT=     c06f7000 000007ff
CR0=8005003b CR2=ffc46000 CR3=00743000 CR4=000006d0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000000
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=800bf60000000000 4015 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000 XMM01=00000000000000000000000000000000
XMM02=00000000000000000000000000000000 XMM03=00000000000000000000000000000000
XMM04=00000000000000000000000000000000 XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000 XMM07=00000000000000000000000000000000

I'll wait a bit with bisect whether You'll spot some obvious bug or not ;)
thanks for Your time!

PS: I still owe You the kvm_stat comparison about this slow windows chkdsk problem,
I'm aware of it, I just had to postpone this due to more urgent matters :(
but I'll get back to it sooner or later..

>
> -- 
> error compiling committee.c: too many arguments to function
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
