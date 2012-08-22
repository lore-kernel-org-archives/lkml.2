Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2HVK4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:56:35 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56693 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2HVK4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:56:32 -0400
Date: Wed, 22 Aug 2012 12:00:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120822120027.7d04fd3a@pyramind.ukuu.org.uk>
In-Reply-To: <20120822090304.GA23336@gmail.com>
References: <20120820080606.GA6931@gmail.com>
	<20120820181651.GA737@srcf.ucam.org>
	<20120821094203.GB12385@gmail.com>
	<20120821113951.GA22436@srcf.ucam.org>
	<20120821151910.GA5359@gmail.com>
	<20120821152828.GB28241@srcf.ucam.org>
	<20120821155908.GA5499@gmail.com>
	<20120821161324.GA29665@srcf.ucam.org>
	<20120821182346.GA7325@gmail.com>
	<20120821195234.20c173bc@pyramind.ukuu.org.uk>
	<20120822090304.GA23336@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With deep enough C states it's rather relevant whether we 
> continue to burn +50W for a couple of more milliseconds or not, 
> and whether we have the right information from the scheduler and 
> timer subsystem about how long the next idle period is expected 
> to be and how bursty a given task is.

50W for 2mS here and there is an irrelevance compared with burning a
continual half a watt due to the upstream tree lack some of the SATA
power patches for example.

It's the classic "standby mode" problem - energy efficiency has time as a
factor and there are a lot of milliseconds in 5 hours. That means
anything continually on rapidly dominates the problem space.

> > PM means fixing the stack top to bottom, and its a whackamole 
> > game, each one you fix you find the next. You have to sort the 
> > entire stack from desktop apps to kernel.
> 
> Moving 'policy' into user-space has been an utter failure, 
> mostly because there's not a single project/subsystem 
> responsible for getting a good result to users. This is why
> I resist "policy should not be in the kernel" meme here.

You *can't* fix PM in one place. Power management is a top to bottom
thing. It starts in the hardware and propogates right to the top of the
user space stack.

A single stupid behaviour in a desktop app is all it needs to knock the
odd hour or two off your battery life. Something is mundane as refreshing
a bit of the display all the time keeping the GPU and CPU from sleeping
well.

Most distros haven't managed to do power management properly because it
is this entire integration problem. Every single piece of the puzzle has
to be in place before you get any serious gain.

It's not a kernel v user thing. The kernel can't fix it, random bits of
userspace can't fix it. This is effectively a "product level" integration
problem.

Alan
