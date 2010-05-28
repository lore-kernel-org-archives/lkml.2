Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0E1Ezb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 00:55:31 -0400
Received: from smtp-out.google.com ([74.125.121.35]:38512 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0E1Eza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 00:55:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=CDITk7Rw30VnHM45jCPSXgPC+UZIYGrZtKDH5sPp3tZKjc61yeL4XD3X0t9svxAuH
	bbAaHevztdjQ69NMea3QA==
MIME-Version: 1.0
In-Reply-To: <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
Date: Thu, 27 May 2010 21:55:26 -0700
Message-ID: <AANLkTimqcVYhRxa4JUaiArPHS4_T7I-kbclhVx_jJOt3@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Brian Swetland <swetland@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 3:55 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> This started because the Android people came to a meeting that was put
> together of various folks to try and sort of the big blockage in getting
> Android and Linux kernels back towards merging.
>
> I am interested right now in finding a general solution to the Android
> case and the fact it looks very similar to the VM, hard RT, gamer and
> other related problems although we seem to have diverged from that logic.

I think that the suspend block model can be viewed as a constraints
problem (similar to some of things things you've been sketching out in
these threads), but I think we (Google/Android) view it as more of a
state constraint (don't enter suspend) than a latency constraint.

We think there's a need for these constraints both from the driver
side and userspace side, and that these constraints are not tied to
processes (multiple entities in one process may have different
constraints at different times or multiple processes may be working
together to accomplish some goal under a single constraint -- at least
both cases exist in the Android system as it ships today).

The exact naming of the API is not terribly important to us.  The
first thing we spent a bunch of time discussing last summer when Arve
first looked into sending wakelocks upstream was changing the name
because many objected to "wakelock" for various reasons.

Being able to have userful statistics (which drivers/processes/etc
held which wakelock for how long, how many times, etc) is important to
us.  While we want to do the best we can in the face of poorly written
apps, we also want to educate users and developers about which apps
are contributing to their poor battery life -- so users can decide to
uninstall an app if its usefulness does not justify its impact on
battery life and application developers can be more aware of what the
cost of their app is to endusers.

As an example, http://frotz.net/misc/battery-stats-unplugged.txt
contains a dump from the "battery service" aggregating wakelock usage,
cpu usage, and sensor device usage of processes (#....: sections) on
my phone the other day for a ~3 hour period.  This data is presented
visually to the enduser in a "what's using my battery" feature of the
platform.  "realtime" refers to wall clock time here and "uptime"
refers to not-in-suspend execution time.

Brian
