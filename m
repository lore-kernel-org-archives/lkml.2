Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2GAIQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 04:16:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58348 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2GAIQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 04:16:14 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.01.1207010247430.7313@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1207010247430.7313@frira.zrqbmnf.qr>
Date: Sun, 1 Jul 2012 01:16:13 -0700
X-Google-Sender-Auth: z4KJbW6ORaY1BHsnYGwbsQ6oDvY
Message-ID: <CANcMJZBcpWzJWCdV8XN6cOUsbykZ-0dre=FBP-zRDhHfi1MwrQ@mail.gmail.com>
Subject: Re: Leap second insertion causes futex to repeatedly timeout
From: john stultz <johnstul@us.ibm.com>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        simon@fire.lp0.eu, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2012 at 5:57 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> This year's leap second insertion has had the strange effect on at least
> Linux versions 3.4.4 (my end) and 3.5-rc4 (Simon's box, Cc) that certain
> processes use up all CPU power, because of futexes repeatedly timing
> out. This seems to only affect certain processes.
>
> Simon observes - http://s85.org/owXfmLvt - that
> Firefox/Thunderbird/Chrome/Java are affected.
>
> As for me, it affects VirtualBox, mysqld and ksoftirqd. The processes
> continue to run and respond. Most weird: I can stop-start mysqld and the
> issue persists. (I would have expected it to go away because the leap
> second event would then be in the past that mysqld does not know about
> anymore.)
>
>
> Is this a kernel issue? glibc?

Some of the reports that the issue is resolved by calling:
       $ date -s "`date`"
suggests that it might be due to clock_was_set() not being called
after the leap second was added, causing some hrtimer confusion.

Thomas: does that sound about right?

I've got an initial patch to add the clock_was_set() calls where
needed, but so far have not been able to reproduce the issue (tried
firefox and some simpler futex tests).  I'll keep trying and hopefully
have something to send out tomorrow.

Again, my apologies for the trouble.
-john
