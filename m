Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab2DWFH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:07:28 -0400
Received: from mail.southpole.se ([193.12.106.18]:55716 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2DWFH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 01:07:27 -0400
Message-ID: <1335157643.5139.37.camel@jerome.southpole.se>
Subject: Re: [PATCH ] leds: add new transient trigger for one shot timer
 support
From: Jonas Bonn <jonas@southpole.se>
To: shuahkhan@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Mon, 23 Apr 2012 07:07:23 +0200
In-Reply-To: <1335138687.2882.20.camel@lorien2>
References: <1333310039.2879.4.camel@lorien2> <1334064283.10826.6.camel@ted>
	 <1334507752.2723.3.camel@lorien2> <1334894674.3051.18.camel@lorien2>
	 <1334983269.2435.90.camel@jerome.southpole.se>
	 <1335138687.2882.20.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 57643-02334
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2012-04-22 at 17:51 -0600, Shuah Khan wrote:
> Hi Jonas,
> 
> activate does sound better and having units in the property name is a
> good idea. Will make the changes including the 0200 change for activate.
> Will change the transient_time to transient_time_msec (no problem using
> duration, just that time is shorter :)

'duration' is shorter than than 'transient_time' :)

I don't think you need to prefix the property with the trigger
namespace... no other trigger does this.  I'm still inclined to say that
'duration' is clearer than 'time'... the length of the property name
can't seriously be an issue here.  Neil also commented that it should be
'delay_on' which has the advantage of being consistent with other
existing triggers.

> 
> > A couple of questions:
> > 
> > i)  Why is it important for you to maintain the LED state?
> One use-case that would be easier for user to comprehend would be to
> have a constant timer that runs periodically. time value doesn't change
> and by simply writing 1 or 0, timer with a value specified by the time
> file can be started. The following use-case is a good example for what I
> am talking about:
> 
> echo transient > trigger
> echo n > transient_time
> repeat the following step as needed:
> echo 1 > transient_enabled - start timer = transient_time to run once
> echo 1 > transient_enabled - start timer = transient_time to run once
> echo none > trigger

> This could be accomplished by simply using just the time property,
> however, each time, the same timer value needs to be echoed. Not a big
> deal, however time value either needs to stay where it is even when a
> timer is not running, or clear it 0. I don't like clearing the time
> value. Here is why. The use-case is very similar to a stop and start
> timer function on a watch for example. I typically set a time
> value and then activate and deactivate as needed without needing to
> reset the time value.
> 

You misunderstood me... it's the not the 'duration' state that I was
asking about, it's the 'illuminated' state.  In your patch you had 3
fields in your trigger data struct... I'd argue you only need two: the
duration and the timer itself; you don't need a field to keep track of
the state of the LED.

> > 
> > ii)  Why do you need to be able to cancel the timer?
> Here is an example where canceling timer is necessary. Phone is in
> silent mode and a call comes in. When call comes in phone will start
> vibrating (maybe vibrate mode set for 2 seconds), when caller answers,
> vibrate mode needs to deactivated right away by stopping the vibrate
> mode and canceling the timer.

OK, this can be accomplished by writing 0 to the 'brightness' value...
you don't need to be able to do this via the 'activate' property.  The
trigger will clean itself up automatically when you do this, too.

> > 
> > As I understand this trigger (and your use-case), this is about being
> > able to turn on a LED (signal) and forget about it, knowing that it will
> > be extinguished in due time without any intervention.  So I would leave
> > it at that; don't even present an option to intervene.
> > 
> > That said, there is already a way to intervene:  I can always write 0 to
> > 'brightness' to extinguish the led immediately.
> 
> That is correct. brightness could be used, however having a distinct
> name-space might be better for future changes instead of overloading
> brightness.

This is a simple trigger that does one thing and does it well; what
future changes do you have in mind?  Will I need to download a PDF
manual and dedicate a weekend to understanding the intricate interplay
of all its properties in the future?

The 'brightness' property will always be there; it doesn't go away just
because you install a trigger for the LED.  It's best to use the
interface that already exists instead of adding a second one that
essentially does the same thing...

> 
> Hope this helps explain my reasoning to keep transient state.
> 

Yeah, for sure... I'd say you're almost there so hang in there!

/Jonas


