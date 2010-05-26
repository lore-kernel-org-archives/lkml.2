Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0EZMgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:36:05 -0400
Received: from www.tglx.de ([62.245.132.106]:50151 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab0EZMgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:36:02 -0400
Date: Wed, 26 May 2010 14:35:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Brian Bloniarz <bmb@athenacr.com>
cc: john stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
In-Reply-To: <4BFC8C77.7020802@athenacr.com>
Message-ID: <alpine.LFD.2.00.1005261432060.2995@localhost.localdomain>
References: <4BF58B59.7080901@athenacr.com>  <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>  <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>  <1274727116.2954.5.camel@localhost.localdomain>  <4BFADF9D.9050209@zytor.com
 1274733566.2954.73.camel@localhost.localdomain>  <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>  <4BFB2902.50308@athenacr.com>  <4BFC687A.9040304@athenacr.com> <1274834888.4678.66.camel@localhost.localdomain>
 <4BFC8C77.7020802@athenacr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Brian Bloniarz wrote:

> john stultz wrote:
> > On Tue, 2010-05-25 at 20:16 -0400, Brian Bloniarz wrote:
> >> On 05/24/2010 09:33 PM, Brian Bloniarz wrote:
> >>> So what's wrong with just adding a
> >>> /sys/devices/system/clocksource/clocksource0/tsc_khz?
> >> As an RFC:
> >>
> >> Add clocksource.sys_register & sys_unregister so the
> >> current clocksource can add supplemental information to
> >> /sys/devices/system/clocksource/clocksource0/
> >>
> >> Export tsc_khz when current_clocksource==tsc so that
> >> daemons like NTP can account for the variability of
> >> calibration results.
> > 
> > I think this is a bad idea, as it creates an ABI that is arch AND
> > machine specific, which will cause portability problems in applications
> > that expect the interface to be there.
> 
> It's an arch-independent ABI that returns ENOENT on
> unsupported platforms ;)
> 
> Could you please explain what you envision as an
> arch-independent solution to this problem?
> I guess the tsc_long_calibration=1 alternative is
> one.

Arch independent solution is to provide information about the current
clock source in general. This is _NOT_ a TSC specific problem, you
have the same trouble with any other clocksource which gets calibrated
and does not take it's frequency as a constant value from boot loader,
configuration or some CPU/chipset register. The only missing piece is
a frequency member in struct clocksource which needs to be filled in
by the arch/machine specific code.

Thanks,

	tglx
