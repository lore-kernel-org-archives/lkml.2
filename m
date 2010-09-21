Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0IUTsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:48:24 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:54030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0IUTsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:48:23 -0400
Subject: Re: [RFC] led-class: always implement blinking
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100921124419.6b88f7f6.akpm@linux-foundation.org>
References: <1282296102.3785.28.camel@jlt3.sipsolutions.net>
	 <20100921124419.6b88f7f6.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 21:48:17 +0200
Message-ID: <1285098497.12764.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 12:44 -0700, Andrew Morton wrote:
> On Fri, 20 Aug 2010 11:21:42 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > +static int led_blink_set(struct led_classdev *led_cdev,
> > +			 unsigned long *delay_on, unsigned long *delay_off)

> > +	if (*delay_on == led_cdev->blink_delay_on &&
> > +	    *delay_off == led_cdev->blink_delay_off)
> > +		return 0;
> > +
> > +	/* deactivate previous settings */
> > +	del_timer_sync(&led_cdev->blink_timer);
> > +
> > +	led_cdev->blink_delay_on = *delay_on;
> > +	led_cdev->blink_delay_off = *delay_off;

> delay_on and delay_off could have been pass-by-value rather than
> pass-by-reference?  That would clean up some gunk in callers, too.
> 
> If there was some reason for doing it with pass-by-reference then that
> reason should have been documented!

Well, this function gets assigned to led_cdev->blink_set(), which is a
function pointer that takes pass-by-reference arguments. The comment
there says:

        /* Activate hardware accelerated blink, delays are in
         * miliseconds and if none is provided then a sensible default
         * should be chosen. The call can adjust the timings if it can't
         * match the values specified exactly. */
        int             (*blink_set)(struct led_classdev *led_cdev,
                                     unsigned long *delay_on,
                                     unsigned long *delay_off);

but the software implementation doesn't adjust the timings, of course. I
suppose the "adjust the timings" was also meant to update the values.

johannes

