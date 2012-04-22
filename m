Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2DVXvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 19:51:32 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:2883 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2DVXvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 19:51:31 -0400
Message-ID: <1335138687.2882.20.camel@lorien2>
Subject: Re: [PATCH ] leds: add new transient trigger for one shot timer
 support
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Jonas Bonn <jonas@southpole.se>
Cc: shuahkhan@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        neilb@suse.de, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Sun, 22 Apr 2012 17:51:27 -0600
In-Reply-To: <1334983269.2435.90.camel@jerome.southpole.se>
References: <1333310039.2879.4.camel@lorien2> <1334064283.10826.6.camel@ted>
	 <1334507752.2723.3.camel@lorien2> <1334894674.3051.18.camel@lorien2>
	 <1334983269.2435.90.camel@jerome.southpole.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,

activate does sound better and having units in the property name is a
good idea. Will make the changes including the 0200 change for activate.
Will change the transient_time to transient_time_msec (no problem using
duration, just that time is shorter :)

> A couple of questions:
> 
> i)  Why is it important for you to maintain the LED state?
One use-case that would be easier for user to comprehend would be to
have a constant timer that runs periodically. time value doesn't change
and by simply writing 1 or 0, timer with a value specified by the time
file can be started. The following use-case is a good example for what I
am talking about:

echo transient > trigger
echo n > transient_time
repeat the following step as needed:
echo 1 > transient_enabled - start timer = transient_time to run once
echo 1 > transient_enabled - start timer = transient_time to run once
echo none > trigger

This could be accomplished by simply using just the time property,
however, each time, the same timer value needs to be echoed. Not a big
deal, however time value either needs to stay where it is even when a
timer is not running, or clear it 0. I don't like clearing the time
value. Here is why. The use-case is very similar to a stop and start
timer function on a watch for example. I typically set a time
value and then activate and deactivate as needed without needing to
reset the time value.

> 
> ii)  Why do you need to be able to cancel the timer?
Here is an example where canceling timer is necessary. Phone is in
silent mode and a call comes in. When call comes in phone will start
vibrating (maybe vibrate mode set for 2 seconds), when caller answers,
vibrate mode needs to deactivated right away by stopping the vibrate
mode and canceling the timer.
> 
> As I understand this trigger (and your use-case), this is about being
> able to turn on a LED (signal) and forget about it, knowing that it will
> be extinguished in due time without any intervention.  So I would leave
> it at that; don't even present an option to intervene.
> 
> That said, there is already a way to intervene:  I can always write 0 to
> 'brightness' to extinguish the led immediately.

That is correct. brightness could be used, however having a distinct
name-space might be better for future changes instead of overloading
brightness.

Hope this helps explain my reasoning to keep transient state.

Thanks,
-- Shuah

