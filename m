Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0E0PYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:24:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58567 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755434Ab0E0PYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:24:43 -0400
Date: Thu, 27 May 2010 16:31:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-14?B?SGr4bm5l?= =?ISO-8859-14?B?duVn?= 
	<arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       <Paul@smtp1.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527163147.5d9880af@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1005271053420.3239-100000@iolanthe.rowland.org>
References: <alpine.LFD.2.00.1005271545190.3032@localhost.localdomain>
	<Pine.LNX.4.44L0.1005271053420.3239-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The proposal I made a couple of days ago removes this API and leaves
> the other things (i.e., the in-kernel suspend blockers and
> opportunistic suspend) intact.  In place of the userspace
> kernel-blocker API, Android would have to implement a power manager
> process that would essentially juggle all the latency requirements in
> userspace.

On the kernel side you really want to add two arguments from day one which
is the time in ms and the power state. We have enumerations of current
power states (plus add suspend) so this is easy to do. The governors may
not use them for a while but ACPI for example can use the latency pretty
fast. You want the information there from day one so it is captured
otherwise it ends up a right royal pain in the arse adjusting the API
later. If the numbers are in but don't always get used it'll be a lot
smoother.

> Communication between the power manager process and the kernel would be 
> limited to adding a new "opportunistic" entry to /sys/power/state -- 
> something which could well be useful in its own right.  Even if this 
> API turns out not to be good, it's simple enough that it could be 
> removed pretty easily.

Yes. Probably it really should be linked to a cpufreq driver thing -
cpufreq_android or whatever being the starting point but thats not a big
deal and it doesn't leak into all the apps either. This is detail however.

> Indeed, having a power manager thread may well turn out to be a useful
> thing -- but even if it doesn't, this scheme minimizes the damage while
> still allowing the Android platform to use a vanilla kernel with only
> limited modifications to their userspace.

There have been some horribly bad attempts to do this, but if it works
for Android and its encapsulated in cpufreq_android.c maybe with a private
interface to a single supporting daemon then it's not creating bad user
APIs, its not peeing in anyone elses pond and the policy will all be in
the kernel and a daemon which keeps the wrong platform knowledge out of
the application space.

Alan
