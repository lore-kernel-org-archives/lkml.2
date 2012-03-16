Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab2CPUGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:06:22 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:62981 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2CPUGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:06:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20323.40245.165190.353107@quad.stoffel.home>
Date: Fri, 16 Mar 2012 16:06:13 -0400
From: "John Stoffel" <john@stoffel.org>
To: simon@mungewell.org
Cc: "John Stoffel" <john@stoffel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Building BarGraph with LED subsystem
In-Reply-To: <683cca338c740abdd522a35dfe3b17a9.squirrel@mungewell.org>
References: <1b29a178dd288b0f17608b5815ca77a5.squirrel@mungewell.org>
	<20323.25792.171143.809563@quad.stoffel.home>
	<f04eb1355e17dbe4ce7bbdd47da0056e.squirrel@mungewell.org>
	<20323.28731.474538.955921@quad.stoffel.home>
	<683cca338c740abdd522a35dfe3b17a9.squirrel@mungewell.org>
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "simon" == simon  <simon@mungewell.org> writes:

>>>> While making the kernel more complex... esp for a feature which is of
>>>> such limited use.
>> 
simon> Is the concept of a bargraph of LEDs really a 'limited use'? I
simon> can think of several uses... I mean isn't flashing or a heart
simon> beat just as limited ;-)
>> 
>> Yes, it's a limited use.  Are 10% of linux users going to have this
>> hardware and use it?

simon> OK I'm not making myself clear, apologies for that.

Thanks for taking the time to make yourself clearer.  Now I understand
what you're trying to do...

simon> I'd be proposing a 'ledtrig-thres' module which is totally
simon> independent of the G27, which would just provide the ability to
simon> light (or dark) a LED depending on a threshold and value.

And why does this need to be in the kernel?  That's what I'm asking.
Make it a library where you do:

     led_thresh(*led1,int value);
     led_thresh(*led2,int value + 300);
     led_thresh(*led3,int value + 600);
     led_thresh(*led4,int value + 900);
     led_thresh(*led5,int value + 1200);
     leds = led_array(*led1, *led2, *led3, *led4, *led5);
     led_on(*leds, 500);

and it lights up the first two LEDs in the array?  You'd need to do
something like this *anyway* in your code so that you can make this
flexible enough to handle arrays with varying numbers of LEDs.  So why
does it need to be in the kernel again?

simon> With a bit of extra code (in this module) multiple LEDs could be 'linked'
simon> to produce a bargraph, by automatically comparing the same value against
simon> their own thresholds.

So how much code is needed in my userspace program to setup and add
these multiple LEDs (which don't have to be physically anywhere near
each other, think house lighting...) to an array which manages them?  

simon> As to the hardware; it could be the G27, a single LED or a
simon> matrix of LEDs slung off one of the other LED subsystem
simon> devices.

simon> I'd want to show RPMs on my G27, but others could display CPU
simon> usage, emulate a VU meter/FFT display, have the 'low memory
simon> panic light' come on, etc...


simon> Once kernel framework is provided it should not need
simon> re-compilation on a case by case basis.

>> If the kernel only provides a way to set the brightness of individual
>> LEDs, why can't you do the rest in userspace?  What if the user wants
>> to have the LEDs run right to left, or visa versa?

simon> I'm just wondering whether writing this as a trigger module is of use to
simon> others. If well defined, lots of uses are possible.

Just write a library that does this and give it out to people.  Then
you can add in dimming and all kinds of other LED tricks as well.  

John

