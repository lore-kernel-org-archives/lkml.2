Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab1AaN3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:29:39 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:59584 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755536Ab1AaN3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:29:38 -0500
Subject: Re: [PATCH] ARM: pxa: fix suspend on PXA3XX
From: Sven Neumann <s.neumann@raumfeld.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
In-Reply-To: <AANLkTimUg=y49H6THn5s7f7v418W68fhAsMLZGnDqabF@mail.gmail.com>
References: <20110124101701.GE16202@n2100.arm.linux.org.uk>
	 <1295864750-1238-1-git-send-email-s.neumann@raumfeld.com>
	 <AANLkTinrxiHx6jX9jFzVzjq5FH-W=MLoDThAtRq2a1zZ@mail.gmail.com>
	 <1296029447.2013.8.camel@sven>
	 <AANLkTimUg=y49H6THn5s7f7v418W68fhAsMLZGnDqabF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Mon, 31 Jan 2011 14:29:18 +0100
Message-ID: <1296480558.25696.2.camel@sven>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1296480578;7d79c1d8;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 22:46 +0800, Eric Miao wrote:
> On Wed, Jan 26, 2011 at 4:10 PM, Sven Neumann <s.neumann@raumfeld.com> wrote:
> > On Wed, 2011-01-26 at 05:06 +0800, Eric Miao wrote:
> >> How about this instead?
> >>
> >> diff --git a/arch/arm/mach-pxa/pm.c b/arch/arm/mach-pxa/pm.c
> >> index 978e1b2..1807c9a 100644
> >> --- a/arch/arm/mach-pxa/pm.c
> >> +++ b/arch/arm/mach-pxa/pm.c
> >> @@ -33,7 +33,7 @@ int pxa_pm_enter(suspend_state_t state)
> >>  #endif
> >>
> >>       /* skip registers saving for standby */
> >> -     if (state != PM_SUSPEND_STANDBY) {
> >> +     if (state != PM_SUSPEND_STANDBY && pxa_cpu_pm_fns->save) {
> >>               pxa_cpu_pm_fns->save(sleep_save);
> >>               /* before sleeping, calculate and save a checksum */
> >>               for (i = 0; i < pxa_cpu_pm_fns->save_count - 1; i++)
> >> @@ -44,7 +44,7 @@ int pxa_pm_enter(suspend_state_t state)
> >>       pxa_cpu_pm_fns->enter(state);
> >>       cpu_init();
> >>
> >> -     if (state != PM_SUSPEND_STANDBY) {
> >> +     if (state != PM_SUSPEND_STANDBY && pxa_cpu_pm_fns->restore) {
> >>               /* after sleeping, validate the checksum */
> >>               for (i = 0; i < pxa_cpu_pm_fns->save_count - 1; i++)
> >>                       checksum += sleep_save[i];
> >>
> >
> > Not sure if that will work as well. With this change the code is
> > skipping more than just the calls to pxa_cpu_pm_fns->save() and
> > pxa_cpu_pm_fns->restore(). In particular it doesn't call
> > pxa_cpu_pm_fns->enter(state).
> >
> 
> Nah, that ->enable() is called if the checksum is incorrect. Please compare
> with the original code?

I see. Well, I've tried your patch and it seems to work as well.


Thanks,
Sven


