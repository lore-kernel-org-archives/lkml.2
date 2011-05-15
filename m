Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438Ab1EOAEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 20:04:38 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:57317 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754900Ab1EOAEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 20:04:37 -0400
Date: Sat, 14 May 2011 20:04:15 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
        Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.38.6 -stable regression: kernel insta-death on boot.
Message-ID: <20110515000415.GA11643@elliptictech.com>
References: <20110514195741.GA10757@elliptictech.com>
 <20110514233609.GA6850@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514233609.GA6850@aftab>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-15 01:36 +0200, Borislav Petkov wrote:
> According to the opcode stream, your machine is #GPing when doing a
> rdmsr on the HWCR MSR:
[...]
> And this is because the enlarging of the erratum 400 interval which the
> commit you bisected to does, forces your machine to use the special C1E
> routine, which, however, barfs due to the fact that your CPU might not
> have that MSR defined - it is _that_ old.
> 
> Just to verify, can you go to http://codemonkey.org.uk/projects/x86info/,
> checkout the git repository, do

Here you go:

  # x86info -a
  x86info v1.29.  Dave Jones 2001-2011
  Feedback to <davej@redhat.com>.
  
  MP Table:
  #	APIC ID	Version	State		Family	Model	Step	Flags
  #	 0	 0x10	 BSP, usable	 15	 4	 8	 0x78bfbff
  
  Family: 15 Model: 4 Stepping: 8
  CPU Model (x86info's best guess): Athlon 64/Mobile Athlon 64/Mobile Athlon XP-M (SH-C0)
  Processor name string (BIOS programmed): AMD Athlon(tm) 64 Processor 3200+
  
  Number of reporting banks : 5
  
              31       23       15       7 
  MCG_STATUS: 11111111 11111111 11111111 11111111
  MCG_CTL:
   Data cache check enabled
    ECC 1 bit error reporting enabled
    ECC multi bit error reporting enabled
    Data cache data parity enabled
    Data cache main tag parity enabled
    Data cache snoop tag parity enabled
    L1 TLB parity enabled
    L2 TLB parity enabled
   Instruction cache check enabled
    ECC 1 bit error reporting enabled
    ECC multi bit error reporting enabled
    Instruction cache data parity enabled
    IC main tag parity enabled
    IC snoop tag parity enabled
    L1 TLB parity enabled
    L2 TLB parity enabled
    Predecode array parity enabled
    Target selector parity enabled
    Read data error enabled
   Bus unit check enabled
    External L2 tag parity error enabled
    L2 partial tag parity error enabled
    System ECC TLB reload error enabled
    L2 ECC TLB reload error enabled
    L2 ECC K7 deallocate enabled
    L2 ECC probe deallocate enabled
    System datareaderror reporting enabled
   Load/Store unit check enabled
    Read data error enable (loads) enabled
    Read data error enable (stores) enabled
  
             31       23       15       7 
  Bank: 0 (0x400)
  MC0CTL:    11111111 11111111 11111111 11111111
  MC0STATUS: 11111111 11111111 11111111 11111111
  MC0ADDR:   11111111 11111111 11111111 11111111
  MC0MISC:   11111111 11111111 11111111 11111111
  
  Bank: 1 (0x404)
  MC1CTL:    11111111 11111111 11111111 11111111
  MC1STATUS: 11111111 11111111 11111111 11111111
  MC1ADDR:   11111111 11111111 11111111 11111111
  MC1MISC:   11111111 11111111 11111111 11111111
  
  Bank: 2 (0x408)
  MC2CTL:    11111111 11111111 11111111 11111111
  MC2STATUS: 11111111 11111111 11111111 11111111
  MC2ADDR:   11111111 11111111 11111111 11111111
  MC2MISC:   11111111 11111111 11111111 11111111
  
  Bank: 3 (0x40c)
  MC3CTL:    11111111 11111111 11111111 11111111
  MC3STATUS: 11111111 11111111 11111111 11111111
  MC3ADDR:   11111111 11111111 11111111 11111111
  MC3MISC:   11111111 11111111 11111111 11111111
  
  Bank: 4 (0x410)
  MC4CTL:    11111111 11111111 11111111 11111111
  MC4STATUS: 11111111 11111111 11111111 11111111
  MC4ADDR:   11111111 11111111 11111111 11111111
  MC4MISC:   11111111 11111111 11111111 11111111
  
  Microcode patch level: 0x1f00000039
  
  PowerNOW! Technology information
  Available features:
  	Temperature sensing diode present.
  	Frequency ID control
  	Voltage ID control
  	Thermal Trip
  
  MSR: 0xc0010041=0x632f31bf0000020c : 01111111 11111111 11111111 11111111
             11111111 11111111 11111111 11111111
  MSR: 0xc0010042=0x0040afd3000c0c0c : 00000000 01111111 11111111 11111111
             11111111 11111111 11111111 11111111
  
  Voltage ID codes: Maximum=1.550V Startup=1.200V Currently=0.800V
  Frequency ID codes: Maximum=10x Startup=10x Currently=10x
  SVM: revision 0, 0 ASIDs
  Address Size: 48 bits virtual, 40 bits physical
  eax in: 0x00000000, eax = 00000001 ebx = 68747541 ecx = 444d4163 edx = 69746e65
  eax in: 0x00000001, eax = 00000f48 ebx = 00000800 ecx = 00000000 edx = 078bfbff
  
  eax in: 0x80000000, eax = 80000018 ebx = 68747541 ecx = 444d4163 edx = 69746e65
  eax in: 0x80000001, eax = 00000f48 ebx = 0000010a ecx = 00000000 edx = e1d3fbff
  eax in: 0x80000002, eax = 20444d41 ebx = 6c687441 ecx = 74286e6f edx = 3620296d
  eax in: 0x80000003, eax = 72502034 ebx = 7365636f ecx = 20726f73 edx = 30303233
  eax in: 0x80000004, eax = 0000002b ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x80000005, eax = ff08ff08 ebx = ff20ff20 ecx = 40020140 edx = 40020140
  eax in: 0x80000006, eax = 00000000 ebx = 42004200 ecx = 04008140 edx = 00000000
  eax in: 0x80000007, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 0000000f
  eax in: 0x80000008, eax = 00003028 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x80000009, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x8000000a, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x8000000b, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x8000000c, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x8000000d, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x8000000e, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x8000000f, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x80000010, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x80000011, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x80000012, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x80000013, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x80000014, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x80000015, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x80000016, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x80000017, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  eax in: 0x80000018, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
  
  L1 Data TLB (2M/4M):        Fully associative. 8 entries.
  L1 Instruction TLB (2M/4M): Fully associative. 8 entries.
  L1 Data TLB (4K):           Fully associative. 32 entries.
  L1 Instruction TLB (4K):    Fully associative. 32 entries.
  L1 Data cache:
  	Size: 64Kb	2-way associative. 
  	lines per tag=1	line size=64 bytes.
  L1 Instruction cache:
  	Size: 64Kb	2-way associative. 
  	lines per tag=1	line size=64 bytes.
  L2 Data TLB (2M/4M):        Disabled. 0 entries.
  L2 Instruction TLB (2M/4M): Disabled. 0 entries.
  L2 Data TLB (4K):           4-way associative. 512 entries.
  L2 Instruction TLB (4K):    4-way associative. 512 entries.
  L2 cache:
  	Size: 1024Kb	16-way associative. 
  	lines per tag=1	line size=64 bytes.
  
  Feature flags:
   fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflsh mmx fxsr sse sse2
  Extended feature flags:
   fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 nx mmxext mmx fxsr lm 3dnowext 3dnow
  
  Long NOPs supported: yes
  
  Connector type: Socket 754
  
  MTRR registers:
  MTRRcap (0xfe): 0x0000000f00000508 (smrr flag: 0x0, wc flag: 0x1, fix flag: 0x1, vcnt field: 0x08 (8))
  MTRRphysBase0 (0x200): 0x0000000000000006 (physbase field:0x0000000 type field: 0x06 (write-back))
  MTRRphysMask0 (0x201): 0x000000ffc0000800 (physmask field:0xffc0000 valid flag: 1)
  MTRRphysBase1 (0x202): 0x00000000e0000001 (physbase field:0x00e0000 type field: 0x01 (write-combining))
  MTRRphysMask1 (0x203): 0x000000fff0000800 (physmask field:0xfff0000 valid flag: 1)
  MTRRphysBase2 (0x204): 0x0000000000000000 (physbase field:0x0000000 type field: 0x00 (uncacheable))
  MTRRphysMask2 (0x205): 0x0000000000000000 (physmask field:0x0000000 valid flag: 0)
  MTRRphysBase3 (0x206): 0x0000000000000000 (physbase field:0x0000000 type field: 0x00 (uncacheable))
  MTRRphysMask3 (0x207): 0x0000000000000000 (physmask field:0x0000000 valid flag: 0)
  MTRRphysBase4 (0x208): 0x0000000000000000 (physbase field:0x0000000 type field: 0x00 (uncacheable))
  MTRRphysMask4 (0x209): 0x0000000000000000 (physmask field:0x0000000 valid flag: 0)
  MTRRphysBase5 (0x20a): 0x0000000000000000 (physbase field:0x0000000 type field: 0x00 (uncacheable))
  MTRRphysMask5 (0x20b): 0x0000000000000000 (physmask field:0x0000000 valid flag: 0)
  MTRRphysBase6 (0x20c): 0x0000000000000000 (physbase field:0x0000000 type field: 0x00 (uncacheable))
  MTRRphysMask6 (0x20d): 0x0000000000000000 (physmask field:0x0000000 valid flag: 0)
  MTRRphysBase7 (0x20e): 0x0000000000000000 (physbase field:0x0000000 type field: 0x00 (uncacheable))
  MTRRphysMask7 (0x20f): 0x0000000000000000 (physmask field:0x0000000 valid flag: 0)
  MTRRfix64K_00000 (0x250): 0x6f2f362f06060606
  MTRRfix16K_80000 (0x258): 0x6f2f362f06060606
  MTRRfix16K_A0000 (0x259): 0x6d2f302f00000000
  MTRRfix4K_C8000 (0x269): 0x6d2f302f00000000
  MTRRfix4K_D0000 0x26a: 0x6d2f302f00000000
  MTRRfix4K_D8000 0x26b: 0x6d2f302f00000000
  MTRRfix4K_E0000 0x26c: 0x6d2f302f00000000
  MTRRfix4K_E8000 0x26d: 0x6d2f302f00000000
  MTRRfix4K_F0000 0x26e: 0x6d2f352f05050505
  MTRRfix4K_F8000 0x26f: 0x6d2f352f05050505
  MTRRdefType (0x2ff): 0x00e8401000000c00 (fixed-range flag: 0x1, mtrr flag: 0x1, type field: 0x00 (uncacheable))
  
  APIC registers:
  APIC MSR Base(0x1b): 			: 0x00000005fee00900
  APIC Local ID				: 0x00000000
  APIC Local Version			: 0x00040010
  APIC Task Priority			: 0x00000000
  APIC Arbitration Priority		: 0x00000000
  APIC Processor Priority 		: 0x00000000
  APIC EOI 				: 0x00000000
  APIC Remote Read 			: 0x00000000
  APIC Logical Destination 		: 0x01000000
  APIC Destination Format 		: 0xffffffff
  APIC Spurious Interrupt Vector 		: 0x000001ff
  APIC In-Service (ISR0)	 		: 0x00000000
  APIC In-Service (ISR1)	 		: 0x00000000
  APIC In-Service (ISR2)	 		: 0x00000000
  APIC In-Service (ISR3)	 		: 0x00000000
  APIC In-Service (ISR4)	 		: 0x00000000
  APIC In-Service (ISR5)	 		: 0x00000000
  APIC In-Service (ISR6)	 		: 0x00000000
  APIC In-Service (ISR7)	 		: 0x00000000
  APIC Trigger Mode (TMR0)	 	: 0x00000000
  APIC Trigger Mode (TMR1)	 	: 0x00000200
  APIC Trigger Mode (TMR2)	 	: 0x02020202
  APIC Trigger Mode (TMR3)	 	: 0x00000202
  APIC Trigger Mode (TMR4)	 	: 0x00000000
  APIC Trigger Mode (TMR5)	 	: 0x00000000
  APIC Trigger Mode (TMR6)	 	: 0x00000000
  APIC Trigger Mode (TMR7)	 	: 0x00000000
  APIC Interrupt Request (IRR00)	 	: 0x00000000
  APIC Interrupt Request (IRR01)	 	: 0x00000000
  APIC Interrupt Request (IRR02)	 	: 0x00000000
  APIC Interrupt Request (IRR03)	 	: 0x00000000
  APIC Interrupt Request (IRR04)	 	: 0x00000000
  APIC Interrupt Request (IRR05)	 	: 0x00000000
  APIC Interrupt Request (IRR06)	 	: 0x00000000
  APIC Interrupt Request (IRR07)	 	: 0x00000000
  APIC Error Status 			: 0x00000000
  APIC LVT CMCI 				: 0x00000000
  APIC Interrupt Command (ICR0)		: 0x00000000
  APIC Interrupt Command (ICR1) 		: 0x00000000
  APIC LVT Timer 				: 0x000000ef
  APIC Thermal Sensor 			: 0x00000000
  APIC LVT Performance Monitoring Counters: 0x00000400
  APIC LVT LINT0 				: 0x00010700
  APIC LVT LINT1 				: 0x00000400
  APIC LVT Error 				: 0x000000fe
  APIC Initial Count (for Timer)		: 0x00003085
  APIC Current Count (for Timer)		: 0x00001bf2
  APIC Divide Configuration (for Timer)	: 0x00000003
  
  Address sizes : 40 bits physical, 48 bits virtual
  1.85GHz processor (estimate).
  
   running at an estimated 1.85GHz

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
