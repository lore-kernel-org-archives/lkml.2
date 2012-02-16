Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2BPOvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:51:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33051 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2BPOvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:51:31 -0500
Message-ID: <1329403876.2293.232.camel@twins>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Date: Thu, 16 Feb 2012 15:51:16 +0100
In-Reply-To: <20120216143132.293c8f50@pyramind.ukuu.org.uk>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
	 <alpine.LFD.2.02.1202151537500.2794@ionos>
	 <20120215145225.GA21448@srcf.ucam.org>
	 <alpine.LFD.2.02.1202152059230.2794@ionos>
	 <20120215202221.GA29552@srcf.ucam.org>
	 <alpine.LFD.2.02.1202152125500.2794@ionos>
	 <20120215203814.GA29795@srcf.ucam.org>
	 <alpine.LFD.2.02.1202152140110.2794@ionos>
	 <20120215204757.GA30275@srcf.ucam.org>
	 <20120216142733.GA15632@srcf.ucam.org>
	 <20120216143132.293c8f50@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 14:31 +0000, Alan Cox wrote:
> > Userspace clearly has an expectation that sleep(0) is magic in some 
> > ill-defined way. We'd be well within our rights to break that 
> > expectation, but I think it's common enough to warrant special casing.
> 
> In historical Unix sleep(0) ends up the nearest equivalent it had to
> triggering a reschedule and giving up the rest of the timeslice.
> 
> I suspect special casing it as yield() isn't far from the right result ?

But why go that way? Using sleep(0) or yield() is pretty much always the
wrong thing to do anyway, this is a great opportunity for all folks to
find these sites and fix them.

Wasn't that what open-source is all about, doing the right thing?

Why should we care about obviously broken crap?

Furthermore, pushing slack to several seconds will also break stuff that
needed those timers to expire sooner, who is going to fix that?

So we've got a stacking of two ill-considered things:
 - applications using yield()/sleep(0)
 - weirdos pushing timer slack to the seconds range

Individually both cause/are borkage, and now you want to add code to the
kernel to mitigate some, but nowhere near all, of it?

What's next, we're actually going to give people their O_PONIES?


