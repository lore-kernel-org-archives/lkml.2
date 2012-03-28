Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab2C1QJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:09:13 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:10277 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326Ab2C1QJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:09:11 -0400
Message-ID: <1332950949.2305.10.camel@lorien2>
Subject: Re: [PATCH] LEDS-One-Shot-Timer-Trigger-implementation
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: NeilBrown <neilb@suse.de>
Cc: shuahkhan@gmail.com, rpurdie@rpsys.net,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 28 Mar 2012 10:09:09 -0600
In-Reply-To: <20120328104544.593f3d1a@notabene.brown>
References: <1332861697.2834.9.camel@lorien2>
	 <20120328104544.593f3d1a@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil,

> 
> In general I approve of this - thanks for your efforts.
> 
> However there are some details that need attention.

Thanks.
> 
> > 
> > This patch implements the one-shot-timer trigger support by enhancing the
> > current led-class and ledtrig-timer drivers to support the following
> > use-cases:
> > 
> > use-case 1:
> > echo one-shot-timer > /sys/class/leds/SOMELED/trigger
> 
> I don't like the name "one-shot-timer".  This name describes how you expect
> the functionality to be used, but not what the actual difference between
> "timer" and "one-shot-timer" is.
> That difference is simply that one-shot-timer does not start an initial
> default blink, while "timer" does.
> So a name like "timer-no-default" would be a more accurate description and so
> should be preferred.

Yes, timer-no-default describes the enhancement I am making, better than
one-shot-timer does. I will generate patch v2 to address your concerns
and will change the name to timer-no-default and update the relevant
code and documentation that goes with the patch to reflect the change.
> 
> 
> > echo 2000 > /sys/class/leds/SOMELED/delay_on
> 
> This command will call led_blink_set with an on time of '2000' and an off
> time of '0'.  This will cause led_set_software_blink to turn the LED on and
> set no off timer.  This is just as bad as starting a default blink - there is
> no guarantee that the LED (or vibrator) will ever be turned off.
> 
> You need to set 'delay_off' to 'forever' first.

Good point. Will update the documentation.
> 
> >
> I think you should also mention here that:
> 
>  - The 'forever' value is stored as 'ULONG_MAX'.  Possibly a 
>        #define FOREVER ULONG_MAX
>    in the code would be appropriate.  This mapping is only used internally,
>    not in the interface.
> 
>  - The led_blink_set function - which takes two pointers to times - has
>    been extended so that a NULL instead of a pointer means "forever".

Will do.

> > +
> 
> I think
>                 return sprintf(buf, "forever\n");
> 
> if the more common usage.
> 
> Also in led_delay_off_show() below.

ok.
> 

> 
> kstrtoul is currently preferred.  It ensures uniform error codes.
> 

Yes. I noticed the checkpatch.pl warnings. This change is better made as
a separate patch. Do you mind if I deferred it and volunteer to fix it
in a separate patch shortly. :)

> 
> > +	
> 
> Do you need to led_trigger_unregister(&timer_led_trigger) if the registration
> of one_shot_timer_led_trigger fails?

Yes, considered that while I was changing this routine, and thought
might be better to leave the registered timer alone when the second
registration fails. I can go either way.

-- Shuah


