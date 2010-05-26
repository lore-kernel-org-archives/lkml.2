Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0EZO1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:27:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20996 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0EZO1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:27:33 -0400
MIME-Version: 1.0
Message-ID: <cab5e5a7-e204-42c1-a70b-1e2960f999f3@default>
Date: Wed, 26 May 2010 07:26:35 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>, Brian Bloniarz <bmb@athenacr.com>
Cc: john stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com>
 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
 <1274727116.2954.5.camel@localhost.localdomain> <4BFADF9D.9050209@zytor.com>
 <1274733566.2954.73.camel@localhost.localdomain>
 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>
 <4BFB2902.50308@athenacr.com> <4BFC687A.9040304@athenacr.com>
 <1274834888.4678.66.camel@localhost.localdomain>
 <4BFC8C77.7020802@athenacr.com
 alpine.LFD.2.00.1005261432060.2995@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005261432060.2995@localhost.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BFD2FAD.0190:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> 
> On Tue, 25 May 2010, Brian Bloniarz wrote:
> 
> > john stultz wrote:
> > > On Tue, 2010-05-25 at 20:16 -0400, Brian Bloniarz wrote:
> > >> On 05/24/2010 09:33 PM, Brian Bloniarz wrote:
> > >>> So what's wrong with just adding a
> > >>> /sys/devices/system/clocksource/clocksource0/tsc_khz?
> > >> As an RFC:
> > >>
> > >> Add clocksource.sys_register & sys_unregister so the
> > >> current clocksource can add supplemental information to
> > >> /sys/devices/system/clocksource/clocksource0/
> > >>
> > >> Export tsc_khz when current_clocksource==tsc so that
> > >> daemons like NTP can account for the variability of
> > >> calibration results.
> > >
> > > I think this is a bad idea, as it creates an ABI that is arch AND
> > > machine specific, which will cause portability problems in
> applications
> > > that expect the interface to be there.
> >
> > It's an arch-independent ABI that returns ENOENT on
> > unsupported platforms ;)
> >
> > Could you please explain what you envision as an
> > arch-independent solution to this problem?
> > I guess the tsc_long_calibration=1 alternative is
> > one.
> 
> Arch independent solution is to provide information about the current
> clock source in general. This is _NOT_ a TSC specific problem, you
> have the same trouble with any other clocksource which gets calibrated
> and does not take it's frequency as a constant value from boot loader,
> configuration or some CPU/chipset register. The only missing piece is
> a frequency member in struct clocksource which needs to be filled in
> by the arch/machine specific code.

Actually there is already a frequency in struct clocksource except
it's represented by the two components: mult and shift.  Maybe
it would be best to expose these instead of khz (for all clocksources)
so as to limit abuse by naive users.

So, Thomas and John, if Brian's patch is modified to provide:

/sys/devices/system/clocksource/clocksource0/current_mult
/sys/devices/system/clocksource/clocksource0/current_shift
and/or
/sys/devices/system/clocksource/clocksource0/current_khz

is that an acceptable arch-independent patch? (And which do
you prefer?)

