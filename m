Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab2DJQyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:54:07 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37457 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab2DJQyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:54:05 -0400
Date: Tue, 10 Apr 2012 17:56:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120410175632.5c11c36e@pyramind.ukuu.org.uk>
In-Reply-To: <20120410151943.GM7499@opensource.wolfsonmicro.com>
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
	<20120410131206.GB31551@sirena.org.uk>
	<20120410142501.6045c6c0@pyramind.ukuu.org.uk>
	<20120410133339.GK7499@opensource.wolfsonmicro.com>
	<20120410144235.1e05efd4@pyramind.ukuu.org.uk>
	<20120410140749.GL7499@opensource.wolfsonmicro.com>
	<20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
	<20120410151943.GM7499@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We can't go around blocking entire platforms because of the IIO blob. I
> > raised this point with the whole previous *generation* of Intel SoC
> > devices about IIO and nothing has been done about it.
> 
> Including by Intel, of course.

Given the responses I got to moving it out of staging were of the "not
yet" and "no" variety it hardly got a request to be worked upon.

> > Get IIO out of staing and we can look at it, until then IIO is staging
> > code, it's not part of the kernel, it may never be part of the kernel,
> > and it should never block actual kernel code.
> 
> That's not where the rest of the embedded community has been coming from
> on this stuff and from a deployment point of view staging isn't really
> that big a blocker to users

Non-staging code cannot depend upon staging code. That is the rule GregKH
laid down. The Intel drivers involved are established non staging drivers
and the gpadc layer is basically cleaning up the fact they all do this
themselves in private right now without any central co-ordination or
abstraction.

> Frankly at this point I don't understand why we can't just lift IIO out
> of staging as-is, perhaps with the userspace ABI nobbled or moved into
> debugfs for the time being if that's still a concern.  Alternatively
> there is the option of you proposing some other generic framework.

I've been saying this for over a year. It's still a huge blob of code
that isn't needed for pure low level stuff, but that's fixable and
something which can eventually be worked upon.

You are trying to make the tail wag the dog. Staging is basically out of
kernel. The x86 stuff is *in kernel*, this driver is the basis of
cleaning it up. We can sort out making it talk to IIO later. Right now
all you are doing is blocking a pile of much needed code cleanups, and
without them you *won't* have an API for the gpadc on Intel, it'll be
hardcoded in each driver still. That will mean you have *zero* change of
getting IIO support at all.

Whether gpadc then adopts an IIO interface is a question to ask later,
after (if) IIO is ever merged. If the platform ever starts using gpadc
for non internal hardware stuff then I'm pretty sure it'll end up adopting
whatever generic GPADC layer eventually emerges simply because we'll want
to share drivers.

Alan
