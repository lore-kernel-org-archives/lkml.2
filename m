Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab0IUVgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:36:38 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:63673 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab0IUVgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:36:37 -0400
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2010 17:36:36 EDT
Subject: Re: [RFC] led-class: always implement blinking
From: Richard Purdie <rpurdie@rpsys.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1285098497.12764.18.camel@jlt3.sipsolutions.net>
References: <1282296102.3785.28.camel@jlt3.sipsolutions.net>
	 <20100921124419.6b88f7f6.akpm@linux-foundation.org>
	 <1285098497.12764.18.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 22:24:08 +0100
Message-ID: <1285104248.1290.551.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 21:48 +0200, Johannes Berg wrote:
> On Tue, 2010-09-21 at 12:44 -0700, Andrew Morton wrote:
> > On Fri, 20 Aug 2010 11:21:42 +0200
> > Johannes Berg <johannes@sipsolutions.net> wrote:
> > 
> > > +static int led_blink_set(struct led_classdev *led_cdev,
> > > +			 unsigned long *delay_on, unsigned long *delay_off)
> 
> > > +	if (*delay_on == led_cdev->blink_delay_on &&
> > > +	    *delay_off == led_cdev->blink_delay_off)
> > > +		return 0;
> > > +
> > > +	/* deactivate previous settings */
> > > +	del_timer_sync(&led_cdev->blink_timer);
> > > +
> > > +	led_cdev->blink_delay_on = *delay_on;
> > > +	led_cdev->blink_delay_off = *delay_off;
> 
> > delay_on and delay_off could have been pass-by-value rather than
> > pass-by-reference?  That would clean up some gunk in callers, too.
> > 
> > If there was some reason for doing it with pass-by-reference then that
> > reason should have been documented!
> 
> Well, this function gets assigned to led_cdev->blink_set(), which is a
> function pointer that takes pass-by-reference arguments. The comment
> there says:
> 
>         /* Activate hardware accelerated blink, delays are in
>          * miliseconds and if none is provided then a sensible default
>          * should be chosen. The call can adjust the timings if it can't
>          * match the values specified exactly. */
>         int             (*blink_set)(struct led_classdev *led_cdev,
>                                      unsigned long *delay_on,
>                                      unsigned long *delay_off);
> 
> but the software implementation doesn't adjust the timings, of course. I
> suppose the "adjust the timings" was also meant to update the values.

The idea was that hardware fallbacks would let the caller know what
values it had actually fallen back to. The software fallback using
timers is generic so doesn't need to change the values.

I've been meaning to look more closely at the patch but I haven't got to
it yet, sorry :(.

Richard

