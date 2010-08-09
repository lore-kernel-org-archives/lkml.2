Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab0HIKSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:18:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50254 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755835Ab0HIKSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:18:32 -0400
Date: Mon, 9 Aug 2010 11:24:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100809112453.77210acc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100808213821.GD3635@thunk.org>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100804195704.GA23681@linux.vnet.ibm.com>
	<20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have to worry about manually killing off applications when memory
> gets low, I actually thought it was incredibly sucky.  It was a
> miniature, badly done laptop.

Likewise I thought the lack of proper multi-tasking apps in Android was
comically bad. Nice device completely wrecked by the inability to flip
between running apps each with their own screen - something that was old
tech in 1990.

It's no use looking at this from an "In my opinion" angle. A proper
solution works for most if not all opinions except maybe around corner
cases.

>   * allowing arbitrary applications that users can interact with
>     simultaneously (which implies a window manager, the need to have
>     the concept of window focus for keyboard input), etc?

That's also untrue as anyone who has worked in industrial control or
entertainment systems will tell you. You may well have fourteen apps
driving fourteen display/input devices and no window manager.

> would agree that in the ideal world, it would be nice if you could
> have applications that make the correct performance/battery
> utilization tradeoff for devices running on 800 mWh batteries, 94,000
> mWh batteries, and while running on the AC mains.  But I don't believe
> that it's likely to be true, and if you want to try to beat up on
> application writers one at a time to be power optimized --- as far as
> I'm concerned, that's an argument *for* suspend blockers, since I'm
> not big believer in plans that begin, "First, you command the tides of
> the sea to go back", King Canute style.  :-)

Suspend blockers drive the system policy part way into the apps, that in
turn makes the apps very vulnerable to change in their environment because
you've specialised them. I am sure that in the Android world it's
considered fine, and that the marketing and business people even like
this binding together - but it doesn't generalise and will blow up in
people's faces in the future.

To consider your tide analogy - suspend blockers is like trying to
program the waves individually. Show me a suspend blocker aware open
office patch 8)

