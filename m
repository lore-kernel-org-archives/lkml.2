Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab0KWGcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 01:32:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46332 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab0KWGcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 01:32:20 -0500
Date: Tue, 23 Nov 2010 07:32:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: "Berg, Johannes" <johannes.berg@intel.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Message-ID: <20101123063200.GA23907@elte.hu>
References: <20101116142027.GC19247@tiehlicka.suse.cz>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
 <20101118082454.GC15928@tiehlicka.suse.cz>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
 <4CEAA151.7050404@arndnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEAA151.7050404@arndnet.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Hannemann <arnd@arndnet.de> wrote:

> Am 18.11.2010 17:52, schrieb Berg, Johannes:
> >>>> it seems that your patch (5ada28bf76752e33dce3d807bf0dfbe6d1b943ad)
> >>>> causes the following compilatation error:
> >>>>   LD      .tmp_vmlinux1
> >>>> drivers/built-in.o: In function `led_trigger_set':
> >>>> drivers/leds/led-triggers.c:116: undefined reference to
> >>>> `led_brightness_set'
> >>>> make[1]: *** [.tmp_vmlinux1] Error 1
> >>>>
> >>>> AFAICS, led_brightness_set is defined in drivers/leds/led-class.c
> >> which
> >>>> is compiled only if CONFIG_LEDS_CLASS is configured which is not my
> >>>> case (after make oldconfig with all default values from 37-rc1).
> >>>>
> >>>> I am not sure what is the right solution whether
> >> CONFIG_LEDS_TRIGGERS
> >>>> should depend on CONFIG_LEDS_CLASS or the patch should be reverted.
> >>>>
> >>>> My config is attached, if somebody need it.
> >>>
> >>> Hmm, we did find that, and I made a patch to fix up the Kconfig, that
> >> apparently hasn't made it in? Bit confused now.
> >>
> >> Does this mean that I should enable CONFIG_LEDS_CLASS to work around
> >> the issue for this moment?
> > 
> > I think that'd be easiest, yes.
> 
> I also ran into this today.
> Any updates or pointer to the patch?

Same here - i'm running into this build bug frequently as well, as of 2.6.37-rc3. 
Please guys at minimum post the pending fix for this.

Thanks,

	Ingo
