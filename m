Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab2LaKW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 05:22:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37499 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab2LaKWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 05:22:55 -0500
Date: Mon, 31 Dec 2012 11:23:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Du Jiulun <dujiulun@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: Fwd: PROBLEM: Random kernel panic & system freeze when watching
 video
Message-ID: <20121231102300.GA1701@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Du Jiulun <dujiulun@gmail.com>, linux-kernel@vger.kernel.org,
	Tony Luck <tony.luck@intel.com>
References: <CAHfmSg2akcYUwDW38g520Fwyr17E5dFDpuUMKejQCfLpQ4pnhQ@mail.gmail.com>
 <CAHfmSg3ug=64vXtsA4EA6xdKaqWRtT7qZW9AG8n92Q+pbDgQEQ@mail.gmail.com>
 <20121230094008.GA28308@x1.alien8.de>
 <CAHfmSg0O90nC3rnkZHAjO_MNjOoU1v8h-LN+jxx=0U+pz7NasQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHfmSg0O90nC3rnkZHAjO_MNjOoU1v8h-LN+jxx=0U+pz7NasQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 02:42:07AM +0800, Du Jiulun wrote:
> CPU 2: Machine Check Exception: 4 Bank 2: b200000000000005
> TSC 6568f53a1cee
> HARDWARE ERROR. This is *NOT* a software problem!
> Please contact your hardware vendor
> CPU 2 BANK 2 TSC 6568f53a1cee
> TIME 1356717945 Sat Dec 29 02:05:45 2012
> STATUS b200000000000005 MCGSTATUS 4
> PROCESSOR 0:20652 TIME 1356717945 SOCKET 0 APIC 1 microcode c
> Run the above through 'mcelog --ascii'
> CPU 0: Machine Check Exception: 4 Bank 2: b200000000000005
> TSC 6568f53a1cfc
> HARDWARE ERROR. This is *NOT* a software problem!
> Please contact your hardware vendor
> CPU 0 BANK 2 TSC 6568f53a1cfc
> TIME 1356717945 Sat Dec 29 02:05:45 2012
> STATUS b200000000000005 MCGSTATUS 4
> PROCESSOR 0:20652 TIME 1356717945 SOCKET 0 APIC 0 microcode c
> Run the above through 'mcelog --ascii'
> Machine check: Processor context corrupt
> 
> It seems that nothing much has come up except those already there.

I had to build the latest mcelog from kernel.org and it tells you a
little bit more: it is an internal parity error. I don't know, though,
what errors reported in bank 2 pertain to on this cpu model - Intel
should know :).

CPU 2 BANK 2 TSC 6568f53a1cee 
TIME 1356717945 Fri Dec 28 19:05:45 2012
MCG status:MCIP 
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal parity error
STATUS b200000000000005 MCGSTATUS 4
CPUID Vendor Intel Family 6 Model 37
SOCKET 0 APIC 1 microcode c
Run the above through 'mcelog --ascii'
CPU 0 BANK 2 TSC 6568f53a1cfc 
TIME 1356717945 Fri Dec 28 19:05:45 2012
MCG status:MCIP 
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal parity error
STATUS b200000000000005 MCGSTATUS 4
CPUID Vendor Intel Family 6 Model 37
SOCKET 0 APIC 0 microcode c
Run the above through 'mcelog --ascii'
Machine check: Processor context corrupt

Question: is this easily reproducible or only sporadic and has happened
only twice up 'til now?

> Since there's something about hardware error, I've got these message
> in *bold* in my booting log: (from "sudo journalctl --line=5000",
> don't know if relevant, sorry if not)

Nah, those are your ACPI tables.

> ACPI: RSDP 000f0410 00024 (v02 _ASUS_)
> ACPI: XSDT aada5e18 0006C (v01 _ASUS_ Notebook 06222004 MSFT 00010013)
> ACPI: FACP aad81c18 000F4 (v04 _ASUS_ Notebook 06222004 MSFT 00010013)
> ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables!
> (20120711/tbfadt-394)
> ACPI BIOS Bug: Warning: 32/64X FACS address mismatch in FADT -
> 0xAADB7F40/0x00000000AADD1D40, using 32 (20120711/tbfadt-521)

Yet another BIOS f*ckup. Oh well, it should be unrelated.

> ACPI: DSDT aad44018 13C72 (v01 _ASUS_ Notebook 00000000 INTL 20051117)
> ACPI: FACS aadb7f40 00040
> ACPI: APIC aada4f18 0008C (v02 _ASUS_ Notebook 06222004 MSFT 00010013)
> ACPI: DBGP aada6f18 00034 (v01 _ASUS_ Notebook 06222004 MSFT 00010013)
> ACPI: ECDT aadd1b18 000C1 (v01 _ASUS_ Notebook 06222004 AMI. 00000003)
> ACPI: SLIC aadb2c18 00176 (v01 _ASUS_ Notebook 06222004 ASUS 00000001)
> ACPI: MCFG aadd0d18 0003C (v01 _ASUS_ Notebook 06222004 MSFT 00000097)
> ACPI: HPET aadd0c98 00038 (v01 _ASUS_ Notebook 06222004 AMI. 00000003)
> ACPI: SSDT aad9f018 009F1 (v01  PmRef    CpuPm 00003000 INTL 20051117)
> ACPI: DMAR aad81f18 000B8 (v01 INTEL  CP_DALE  00000001 INTL 00000001)
> 
> perf_event_intel: CPUID marked event: 'bus cycles' unavailable
> 
> mtrr: your CPUs had inconsistent variable MTRR settings

Yep, more BIOS f*ckup. By the look of it, I wouldn't wonder if BIOS is
misprogramming something and causing those MCEs.

By the way, can you boot vanilla 3.7 and send the _whole_ dmesg?

Thanks.

-- 
Regards/Gruss,
Boris.
