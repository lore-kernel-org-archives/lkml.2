Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0E1HBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:01:23 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:63386 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab0E1HBT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:01:19 -0400
MIME-Version: 1.0
In-Reply-To: <20100528064356.GA2455@ucw.cz>
References: <20100505202826.GB7450@linux.intel.com>
	<Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
	<z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
	<20100505234755.GI29604@atomide.com>
	<l2ra55d774e1005051656wbf4f3d7cr8cc9de0478e509f1@mail.gmail.com>
	<20100506000552.GJ29604@atomide.com>
	<g2yd6200be21005052116n5dd8708fk33eaf8944379bfc2@mail.gmail.com>
	<20100506170420.GB30928@atomide.com>
	<i2od6200be21005061710mae9a437by90b22f61cbc2ae15@mail.gmail.com>
	<20100528064356.GA2455@ucw.cz>
Date: Fri, 28 May 2010 00:01:17 -0700
Message-ID: <AANLkTinJZtdUQQqXk2WY6fRAQSFshy55rroJG8HrHIOT@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:43 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> >> How often would we retry suspending?
>> >> >
>> >> > Well based on some timer, the same way the screen blanks? Or five
>> >> > seconds of no audio play? So if the suspend fails, then reset whatever
>> >> > userspace suspend policy timers.
>> >> >
>> >> >> If we fail to suspend, don't we have to resume all the drivers that
>> >> >> suspended before the one that failed?  (Maybe I'm mistaken here)
>> >> >
>> >> > Sure, but I guess that should be a rare event that only happens when
>> >> > you try to suspend and something interrupts the suspend.
>> >> >
>> >>
>> >> This is not a rare event. For example, the matrix keypad driver blocks
>> >> suspend when a key is down so it can scan the matrix.
>> >
>> > Sure, but how many times per day are you suspending?
>>
>> How many times we successfully suspend is irrelevant here. If the
>> driver blocks suspend the number of suspend attempts depend on your
>> poll frequency.
>
> Actually, this is quite interesting question I'd like answer here:
>
> "Sure, but how many times per day are you suspending?"
>
> I suspect it may be in 1000s, but it would be cool to get better
> answer -- so that people knew what we are talking about here.

This is highly variable. 1000s would mean that you wake about once
every minute which is not uncommon, but more often than what typically
happens on an idle device. The nexus one has to wake up every 10
minutes to check the battery status check means your at least in the
100s, but the G1 could stay suspended for much longer than that.

The original question was about a driver blocking suspend though, and
if we were to just retry suspend until it succeeds in that case you
could easily get to 100000s suspend attempts in a day.

-- 
Arve Hjønnevåg
