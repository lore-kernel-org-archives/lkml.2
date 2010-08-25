Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0HYMsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 08:48:39 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:32644
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751862Ab0HYMsg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 08:48:36 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1dbaL1432N98dNzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7PKSC-02-A5E-02
X-M-MSG: 
Date: Wed, 25 Aug 2010 15:04:54 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Borislav Petkov <bp@amd64.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Alok Kataria <akataria@vmware.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] x86, tsc: Limit CPU frequency calibration on AMD
Message-ID: <20100825130454.GB4891@loge.amd.com>
References: <1282063532.4388.8.camel@ank32.eng.vmware.com>
 <20100817185634.GA10597@liondog.tnic>
 <20100818161639.GF9880@aftab>
 <4C6C08EC.2080404@zytor.com>
 <20100818173401.GG9880@aftab>
 <1282153895.15158.45.camel@ank32.eng.vmware.com>
 <20100818184534.GA12842@aftab>
 <20100824155305.GA18220@aftab>
 <4C7448A3.2030309@zytor.com>
 <20100825070653.GA25672@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20100825070653.GA25672@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 03:06:53AM -0400, Borislav Petkov wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Tue, Aug 24, 2010 at 06:33:07PM -0400
> 
> > Build failure:
> > 
> > /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c: In
> > function ‘amd_calibrate_cpu’:
> > /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:397: error:
> > implicit declaration of function ‘avail_to_resrv_perfctr_nmi_bit’
> > /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:409: error:
> > implicit declaration of function ‘reserve_perfctr_nmi’
> > /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:410: error:
> > implicit declaration of function ‘reserve_evntsel_nmi’
> > /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:429: error:
> > implicit declaration of function ‘release_perfctr_nmi’
> > /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:430: error:
> > implicit declaration of function ‘release_evntsel_nmi’
> > 
> > Reproducible by doing "make ARCH=i386 allnoconfig".
> 
> Sh*t, I can't catch a break with that Kconfig dependency stuff, can I?
> 
> This happens because perfctr-watchdog.c gets pulled in by
> CONFIG_X86_LOCAL_APIC which is, _of course_, not selected in an
> allnoconfig build. Fixing this would mean exporting all that perfcounter
> reservation functionality for the allnoconfig case, which is of course
> doable but I'm starting to question the need for recalibrating the TSC
> at all:
> 
> I mean, in the 99% of the cases MSRC001_0015[24] should be set by the
> BIOS and if not then the BIOS which does that is pretty b0rked anyway.
> So I'm thinking of removing the recalibration code and simply warning
> the user instead, for the 1% case.
> 
> Andreas, what do you think?

I opt for removing the recalibration code plus keeping a FIRMWARE_WARN
for borked BIOSes (just in case that there are any old systems with
the wrong setting).


Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Alberto Bozzo, Andrew Bowd
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


