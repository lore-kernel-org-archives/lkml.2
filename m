Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab0E1PSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:18:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48412 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750916Ab0E1PSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:18:36 -0400
Date: Fri, 28 May 2010 16:24:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528162457.6f655695@lxorguk.ukuu.org.uk>
In-Reply-To: <20100528140237.GD25798@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com>
	<20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
	<AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com>
	<20100528132138.2d802d77@lxorguk.ukuu.org.uk>
	<20100528123110.GA23930@srcf.ucam.org>
	<20100528145420.1c06e4a3@lxorguk.ukuu.org.uk>
	<20100528140237.GD25798@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 15:02:37 +0100
> Ok, I think I've misunderstood you. You're actually saying that only 
> applications that are trusted to behave well are allowed to receive 
> wakeup events? Yes, that makes implementation significantly easier. If 

To receive them in a manner that they are permitted to defer a suspend.
There is non reason why bouncing cows shouldn't get to see an event, but
there is always the miniscule possibility that we choose to suspend as it
gets the event.

That to me seems fine. Our starting basis was

- Bouncing cows is not trusted

Android's reaction was

- We reserve the right to suspend bouncing cows where it likes it or not

The caveat becomes

- Bouncing cows may get suspended then get an event when the phone wakes
  back up. So I might press "Moo" just before a suspend and get the noise
  when it resumes.

Given the untrusted cows could respond to the event otherwise by blocking
the suspend for as long as permitted with a suspend blocker or similar
that seems no worse. In this case probably better [oof zap! as opposed to
60 seconds of 'event, no sorry got a cow to draw at 100% CPU')

As the app is untrusted we can't assume they would get suspend blockers
right even if they had any.

You can still be nice to the cows app and when the phone is put down send
it a 10 second warning via dbus or Android equivalents.

Your trusted call handling app can still request (by QoS or big hammers)
that the phone does not suspend even if the app goes idle (because you
have a wakeup latency QoS)

A naïve trusted app will behave according to power management idling to
suspend and get stopped

A naïve untrusted app that is doing sane things will spend most of its
life asleep and behave.

