Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab0E0U4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:56:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60828 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756891Ab0E0U4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:56:18 -0400
Date: Thu, 27 May 2010 22:03:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527220314.312d9e3c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527175920.GE3543@srcf.ucam.org>
References: <20100527171644.GA2468@srcf.ucam.org>
	<1274980856.27810.5582.camel@twins>
	<20100527172510.GC2468@srcf.ucam.org>
	<1274981288.27810.5609.camel@twins>
	<20100527173218.GF2468@srcf.ucam.org>
	<1274981750.27810.5641.camel@twins>
	<20100527174140.GB3187@srcf.ucam.org>
	<1274982397.27810.5679.camel@twins>
	<20100527175258.GB3543@srcf.ucam.org>
	<1274982981.27810.5719.camel@twins>
	<20100527175920.GE3543@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 18:59:20 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, May 27, 2010 at 07:56:21PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-05-27 at 18:52 +0100, Matthew Garrett wrote:
> > 
> > > If that's what you're aiming for then you don't need to block 
> > > applications on hardware access because they should all already have 
> > > idled themselves.
> > 
> > Correct, a well behaved app would have. I thought we all agreed that
> > well behaved apps weren't the problem?
> 
> Ok. So the existing badly-behaved application ignores your request and 
> then gets blocked. And now it no longer responds to wakeup events. So 
> you penalise well-behaved applications without providing any benefits to 
> badly-behaved ones.

I don't see how you put the first two sentences together and get the
final one.

When you beat up badly behaved apps that doesn't penalise well behaved
ones.

Forcing "well behaved apps" to make hundreds of extra calls to a complex
blocker interface that also requires tons of kernel code and requires the
application know platform policy and be recompiled if it changes - now
that is punishing well behaved apps.

A well behaved app should just work using standard existing APIs because
that is how all the standard current well behaved apps are written [1].

Alan
--
[1] I'm dying to see the suspend blocker patch for evolution ;)
