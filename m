Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab0EZOlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:41:53 -0400
Received: from www.tglx.de ([62.245.132.106]:49468 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab0EZOlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:41:51 -0400
Date: Wed, 26 May 2010 16:41:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
cc: Brian Bloniarz <bmb@athenacr.com>, john stultz <johnstul@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
In-Reply-To: <cab5e5a7-e204-42c1-a70b-1e2960f999f3@default>
Message-ID: <alpine.LFD.2.00.1005261631550.2995@localhost.localdomain>
References: <4BF58B59.7080901@athenacr.com> <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com> <ce764b91-11b0-44a5-9cf9-96977652bbd5@default> <1274727116.2954.5.camel@localhost.localdomain> <4BFADF9D.9050209@zytor.com> <1274733566.2954.73.camel@localhost.localdomain>
 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com> <4BFB2902.50308@athenacr.com> <4BFC687A.9040304@athenacr.com> <1274834888.4678.66.camel@localhost.localdomain> <4BFC8C77.7020802@athenacr.com alpine.LFD.2.00.1005261432060.2995@localhost.localdomain>
 <cab5e5a7-e204-42c1-a70b-1e2960f999f3@default>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Dan Magenheimer wrote:
> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> >
> > Arch independent solution is to provide information about the current
> > clock source in general. This is _NOT_ a TSC specific problem, you
> > have the same trouble with any other clocksource which gets calibrated
> > and does not take it's frequency as a constant value from boot loader,
> > configuration or some CPU/chipset register. The only missing piece is
> > a frequency member in struct clocksource which needs to be filled in
> > by the arch/machine specific code.
> 
> Actually there is already a frequency in struct clocksource except
> it's represented by the two components: mult and shift.  Maybe
> it would be best to expose these instead of khz (for all clocksources)
> so as to limit abuse by naive users.

You mean the TSC user space ones ?

> So, Thomas and John, if Brian's patch is modified to provide:
> 
> /sys/devices/system/clocksource/clocksource0/current_mult
> /sys/devices/system/clocksource/clocksource0/current_shift
> and/or
> /sys/devices/system/clocksource/clocksource0/current_khz
> 
> is that an acceptable arch-independent patch? (And which do
> you prefer?)

I'd rather prefer the frequency interface for a simple reason. It
allows to add a commandline option which provides the NTP folks with a
sensible solution to their calibration problem as I don't see that a
longer calibration time will reliably fix it.

So we'd get a "clocksource_freq=XXX" option which would be applied to
the clocksource which is selected on the command line with
"clocksource=NNN".

John ?

Thanks,

	tglx
