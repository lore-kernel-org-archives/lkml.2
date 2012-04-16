Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab2DPXF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:05:27 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33876 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab2DPXF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:05:26 -0400
Message-ID: <1334617524.2842.7.camel@lorien2>
Subject: Re: [PATCH 1/1] leds: add "kickable" LED trigger
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Jonas Bonn <jonas@southpole.se>
Cc: shuahkhan@gmail.com, akpm@linux-foundation.org, neilb@suse.de,
        linux-kernel@vger.kernel.org, richard.purdie@linuxfoundation.org
Date: Mon, 16 Apr 2012 17:05:24 -0600
In-Reply-To: <1334615623.25933.29.camel@jerome.southpole.se>
References: <1334507752.2723.3.camel@lorien2>
	 <1334529245-14385-1-git-send-email-jonas@southpole.se>
	 <CACM3HyFjgLPNmFwJKObuPkjQMT5u3b=4kRC+b9yqeNoTdhgHAA@mail.gmail.com>
	 <1334590122.2218.4.camel@lorien2>
	 <1334615623.25933.29.camel@jerome.southpole.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 00:33 +0200, Jonas Bonn wrote:
> Hi Shuah,
> 
> Nice work!  If I may comment on this briefly:
> 
> i)  The semantics of this patch make me cringe.  It's bad enough that
> this is a "LED" trigger; having a "vibrating LED" is even worse.
> Really, this is a GPIO trigger (which is reasonably logical); secondly,
> this trigger is about maintaining a transient state given some criteria.
> 
> ii)  Why force the trigger to a fixed duration?  The point, if I
> understand correctly, is to return to the "rest state" after a given
> time in case the triggering entity dies; but if the triggering entity
> (userspace application) is still alive, why not let it prolong the
> "active state" by triggering again.  This is along the lines of the
> 'kickable' trigger patch I posted earlier.
> 
> iii)  I don't see the point of maintaining the state.  The state is
> maintained by the fact that you have running timer; if the timer is not
> running, the state is the "rest state".
> 
> I'd suggest:
> 
> i)  Calling this ledtrig-transient
> ii)  Having a property 'duration' that determines how long the
> GPIO/LED/signal is 'active'
> iii) Having a property 'activate' (or 'tickle'!) that just sets the
> 'active' state if it isn't already active; writing to this properly
> while active just resets the timer to 0 so that another full 'duration'
> can pass before the LED deactivates.
> iv)  Maybe having a property 'active-state' to decide whether the LED is
> on or off when active; this isn't strictly necessary as the LED class
> already has the active-low property to invert the meaning of the ON
> state.
> 
> This would allow this trigger to be used for a bunch of different use
> cases:
> 
> i)   Control of vibrator by userspace app.
> ii)  Use of LED by userspace app as activity indicator.
> iii) Use of LED by userspace app as a kind of watchdog indicator -- as
> long as the app is alive, it can keep the LED illuminated, if it dies
> the LED will be extinguished automatically.
> iv)  Use by any userspace app that needs a transient GPIO output.
> 
> I hope that makes sense.  It mostly comes down to semantics... the
> implementation is mostly fine, with the exception of maintaining the
> illumination state that I don't see the need for.
> 
> /Jonas

Jonas,

Thanks for the feedback. I better change the name before too long :)
Thanks for summarizing the use-cases. I like your duration and activate
idea. I am testing the patch now and will incorporate your ideas. I
would like to include you in the thread when I send it out if you don't
mind. Thanks again,

-- Shuah

