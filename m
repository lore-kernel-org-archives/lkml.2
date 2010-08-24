Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0HXWeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:34:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45095 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab0HXWe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:34:28 -0400
Message-ID: <4C7448A3.2030309@zytor.com>
Date: Tue, 24 Aug 2010 15:33:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] x86, tsc: Limit CPU frequency calibration on AMD
References: <1282024311.20786.2.camel@ank32.eng.vmware.com> <4C6A2C98.4060605@zytor.com> <20100817070520.GD32714@liondog.tnic> <1282063532.4388.8.camel@ank32.eng.vmware.com> <20100817185634.GA10597@liondog.tnic> <20100818161639.GF9880@aftab> <4C6C08EC.2080404@zytor.com> <20100818173401.GG9880@aftab> <1282153895.15158.45.camel@ank32.eng.vmware.com> <20100818184534.GA12842@aftab> <20100824155305.GA18220@aftab>
In-Reply-To: <20100824155305.GA18220@aftab>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2010 08:53 AM, Borislav Petkov wrote:
> 6b37f5a20c0e5c334c010a587058354215433e92 introduced the CPU frequency
> calibration code for AMD CPUs whose TSCs didn't increment with the
> core's P0 frequency. From F10h, revB onward, the TSC increment rate is
> denoted by MSRC001_0015[24] and when this bit is set (which is normally
> done by the BIOS,) the TSC increments with the P0 frequency so the
> calibration is not needed and booting can be a couple of mcecs faster on
> those machines.
> 
> While at it, make the code work on 32-bit. In addition, use the 4th
> perfctr since using perfctr 0 might clash with perfctr-watchdog.c during
> LAPIC init. Finally, warn about wrongly calibrated value in the most
> seldom cases when the core TSC is not incrementing with P0 frequency.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
> 
> Here's the new version, had to change quite a lot and check all families
> first.
> 

Build failure:

/home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c: In
function ‘amd_calibrate_cpu’:
/home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:397: error:
implicit declaration of function ‘avail_to_resrv_perfctr_nmi_bit’
/home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:409: error:
implicit declaration of function ‘reserve_perfctr_nmi’
/home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:410: error:
implicit declaration of function ‘reserve_evntsel_nmi’
/home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:429: error:
implicit declaration of function ‘release_perfctr_nmi’
/home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:430: error:
implicit declaration of function ‘release_evntsel_nmi’

Reproducible by doing "make ARCH=i386 allnoconfig".

	-hpa
