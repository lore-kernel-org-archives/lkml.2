Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab0EZQZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:25:21 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43734 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab0EZQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:25:19 -0400
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
In-Reply-To: <4BFD4629.6040602@athenacr.com>
References: <4BF58B59.7080901@athenacr.com>
	 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
	 <1274727116.2954.5.camel@localhost.localdomain>
	 <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain>
	 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>
	 <4BFB2902.50308@athenacr.com>  <4BFC687A.9040304@athenacr.com>
	 <1274834888.4678.66.camel@localhost.localdomain>
	 <4BFC8C77.7020802@athenacr.com> <1274886299.1759.8.camel@work-vm>
	 <4BFD4629.6040602@athenacr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 09:25:09 -0700
Message-ID: <1274891109.1759.27.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 12:02 -0400, Brian Bloniarz wrote:
> On 05/26/2010 11:04 AM, john stultz wrote:
> > Right but having applications add "Linux on x86 where the TSC is being
> > used" logic is pretty poor solution. Its an issue that should be
> > addressed from the kernel side.
> 
> Yeah, sure.
> 
> > And really, if apps really wanted this info, they can fish it out
> > of /proc/cpuinfo.
> Really? I was under the impression that tsc_khz can differ
> from cpu_mhz (invariant tsc?), and cpu_mhz can differ from what
> shows up in /proc/cpuinfo cpuMHz due to cpufreq scaling. I was
> also under the impression that knowing or controlling tsc_khz
> is what NTP needs to ensure stability (assuming the TSC is
> otherwise stable, i.e. no halts-in-idle, NMI etc etc weirdness).

Bah. You're right. I shouldn't be emailing this early :)

Even so, I'm still not a fan of the "expose raw details so userland apps
can hack around the kernel's inadequacies" approach.

> Dan Magenheimer wrote:
> > /sys/devices/system/clocksource/clocksource0/current_khz
> >
> > is that an acceptable arch-independent patch? (And which do
> > you prefer?)
> 
> Thomas Gleixner:
> > I'd rather see a generic solution which provides the information of
> > the current (and possibly those of the available) clock source(s). 

While I'm not a huge fan of it, Thomas' way would be a bit more
palatable. 

NTP can check the initial freq the clocksource was registered and if its
different from the last boot decide if it can recalculate that into a
new correction factor, or just throw out the drift file value.

Brian: is this something the NTPd folks actually want? Has anyone
checked with them before we hand down the solution from high upon on
lkml mountain?

Personally I think NTPd should be a little more savvy about how far it
trusts the drift file when it starts up. Since I believe its
fast-startup mode can quickly estimate the drift well within 100ppm,
which is about the maximum variance I've seen from the calibration code.

thanks
-john

