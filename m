Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0EZPFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:05:31 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37907 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab0EZPFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:05:30 -0400
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: john stultz <johnstul@us.ibm.com>
To: Brian Bloniarz <bmb@athenacr.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4BFC8C77.7020802@athenacr.com>
References: <4BF58B59.7080901@athenacr.com>
	 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
	 <1274727116.2954.5.camel@localhost.localdomain>
	 <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain>
	 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>
	 <4BFB2902.50308@athenacr.com>  <4BFC687A.9040304@athenacr.com>
	 <1274834888.4678.66.camel@localhost.localdomain>
	 <4BFC8C77.7020802@athenacr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 08:04:59 -0700
Message-ID: <1274886299.1759.8.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 22:50 -0400, Brian Bloniarz wrote:
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

Right but having applications add "Linux on x86 where the TSC is being
used" logic is pretty poor solution. Its an issue that should be
addressed from the kernel side.

And really, if apps really wanted this info, they can fish it out
of /proc/cpuinfo.

> Could you please explain what you envision as an
> arch-independent solution to this problem?
> I guess the tsc_long_calibration=1 alternative is
> one.

...and the tsc_khz= patch I posted earlier.


thanks
-john


