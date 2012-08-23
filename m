Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2HWHFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:05:37 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:57400 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755593Ab2HWHFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:05:32 -0400
MIME-Version: 1.0
In-Reply-To: <201208221722.06775.arnd@arndb.de>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de>
 <1345648390-4234-3-git-send-email-arnd@arndb.de> <CAMQu2gw0x6saWrK-M3teu49tJDGvS8RhGrVSh6JTs5DEy+22pA@mail.gmail.com>
 <201208221722.06775.arnd@arndb.de>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 23 Aug 2012 12:35:08 +0530
Message-ID: <CAMQu2gw_090MiWxs6m=5o0wQhL=ovmN1Y_7DUVhTbJU6mHPS5Q@mail.gmail.com>
Subject: Re: [PATCH 2/6] ARM: omap: allow building omap44xx without SMP
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 10:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wednesday 22 August 2012, Shilimkar, Santosh wrote:
>
> > Was just thinking whether we should just take care of it at
> > core cpuidle level itself. Will below be enough to kill the build
> > error what you mentioned in the change log ?
> >
> > diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> > index 2c9bf26..df34534 100644
> > --- a/drivers/cpuidle/coupled.c
> > +++ b/drivers/cpuidle/coupled.c
> > @@ -314,7 +314,9 @@ static void cpuidle_coupled_poke(int cpu)
> >         struct call_single_data *csd = &per_cpu(cpuidle_coupled_poke_cb,
> > cpu);
> >
> >         if (!cpumask_test_and_set_cpu(cpu, &cpuidle_coupled_poked_mask))
> > +#ifdef CONFIG_SMP
> >                 __smp_call_function_single(cpu, csd, 0);
> > +#endif
> >  }
> >
>
> That would work, but isn't the entire concept of the cpuidle-coupled
> driver
> dependent on SMP? If this driver makes no sense on UP, I think we should
> not attempt to build it.
>
I see your point but alternate patch is pushing down the fix to the low
level driver and that means you end up patching more drivers when they
use COUPLE idle infrastructure. That was the only reason I was thinking
of suppressing the error at the source.

Since it is just for the random builds and actually doesn't impact the real
functionality as such, I am fine with your proposed patch too.

Regards
santosh
