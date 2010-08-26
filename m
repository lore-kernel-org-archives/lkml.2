Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0HZHTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:19:19 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43817 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0HZHTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:19:16 -0400
Date: Thu, 26 Aug 2010 09:19:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alok Kataria <akataria@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3] x86, tsc: Remove CPU frequency calibration on AMD
Message-ID: <20100826071948.GA980@aftab>
References: <4C6C08EC.2080404@zytor.com>
 <20100818173401.GG9880@aftab>
 <1282153895.15158.45.camel@ank32.eng.vmware.com>
 <20100818184534.GA12842@aftab>
 <20100824155305.GA18220@aftab>
 <4C7448A3.2030309@zytor.com>
 <20100825070653.GA25672@aftab>
 <20100825130454.GB4891@loge.amd.com>
 <20100825162823.GE26438@aftab>
 <1282775588.4486.11.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282775588.4486.11.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alok Kataria <akataria@vmware.com>
Date: Wed, Aug 25, 2010 at 06:33:08PM -0400

> 
> On Wed, 2010-08-25 at 09:28 -0700, Borislav Petkov wrote:
> > 6b37f5a20c0e5c334c010a587058354215433e92 introduced the CPU frequency
> > calibration code for AMD CPUs whose TSCs didn't increment with the
> > core's P0 frequency. From F10h, revB onward, however, the TSC increment
> > rate is denoted by MSRC001_0015[24] and when this bit is set (which
> > should be done by the BIOS) the TSC increments with the P0 frequency
> > so the calibration is not needed and booting can be a couple of mcecs
> > faster on those machines.
> > 
> > Besides, there should be virtually no machines out there which don't
> > have this bit set, therefore this calibration can be safely removed. It
> > is a shaky hack anyway since it assumes implicitly that the core is in
> > P0 when BIOS hands off to the OS, which might not always be the case.
> 
> Nice... this works for us too, we don't muck with that MSR bit either,
> its directly passed as is from the h/w to the guest. So no additional
> changes would be needed for us with this.

That's nice, KVM appears to not hit it either due to unsynchronized
TSCs.

> Hope that the 3rd time is a charm for you too :)

Yeah, I think it is :). Sorry for taking so long but removing code which
is actively executed from the kernel is not such a light decision. But
the hw guys made sure that this bit is always set so we don't need the
calibration. It wouldn't work in all cases anyway (hint: boosted cores).

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
