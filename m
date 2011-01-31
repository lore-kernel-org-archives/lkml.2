Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab1AaMdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:33:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38695 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab1AaMdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:33:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=QeuBjb2l66ZgAoam6ZwQkghe8yDHB5Yfy9YFv2SlZRkal+/HEEZGukDAoTissVELO8
         2pSwEZ5KQelHLIKcBd5AFluMWHjvGi4eqIypSm8X3toNaunPYIcW8bxBla4I2cqQvbdW
         4kc3Bkj39AgFsdBLBqYMceuDJemUd3g6MpX0g=
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: pxa: fix suspend on PXA3XX
Date: Mon, 31 Jan 2011 13:36:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: Eric Miao <eric.y.miao@gmail.com>, Sven Neumann <s.neumann@raumfeld.com>,
        Daniel Mack <daniel@caiaq.de>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <20110124101701.GE16202@n2100.arm.linux.org.uk> <1296029447.2013.8.camel@sven> <AANLkTimUg=y49H6THn5s7f7v418W68fhAsMLZGnDqabF@mail.gmail.com>
In-Reply-To: <AANLkTimUg=y49H6THn5s7f7v418W68fhAsMLZGnDqabF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101311336.09994.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 January 2011 15:46:54 Eric Miao wrote:
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
> > 
> > Not sure if that will work as well. With this change the code is
> > skipping more than just the calls to pxa_cpu_pm_fns->save() and
> > pxa_cpu_pm_fns->restore(). In particular it doesn't call
> > pxa_cpu_pm_fns->enter(state).
> 
> Nah, that ->enable() is called if the checksum is incorrect. Please compare
> with the original code?

I won't hesitate to Ack Eric's code. It looks to me as a much cleaner solution.
> 
> > Thanks,
> > Sven
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
