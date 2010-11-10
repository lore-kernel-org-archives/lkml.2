Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab0KJWOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:14:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55504 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab0KJWOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:14:15 -0500
Date: Wed, 10 Nov 2010 15:14:12 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Maciej Szmigiero <mhej@o2.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Ben Nizette <bn@niasdigital.com>
Subject: Re: [GPIO]implement sleeping GPIO chip removal
Message-ID: <20101110221412.GB7063@angua.secretlab.ca>
References: <4CD6F049.10102@o2.pl>
 <20101110050947.GC4110@angua.secretlab.ca>
 <4CDABA03.2050000@o2.pl>
 <alpine.LFD.2.00.1011102134350.2900@localhost6.localdomain6>
 <4CDB0834.4080101@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDB0834.4080101@o2.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 10:01:40PM +0100, Maciej Szmigiero wrote:
> W dniu 10.11.2010 21:42, Thomas Gleixner pisze:
> > On Wed, 10 Nov 2010, Maciej Szmigiero wrote:
> >> W dniu 10.11.2010 10:49, Thomas Gleixner pisze:
> >>> Maybe because it open codes a sloppy refcounting with a loop and magic
> >>> sleeps instead of converting the code to kobjects and proper
> >>> refcounting ?
> >>>
> >>
> >> The only way to do GPIO chip removal in the current code is to busy-loop.
> >> "Sloppy" (as you called it) waiting is still more CPU-friendly than looping 
> >> in hope that somebody will finally release the chip.
> >> If you would like to implement it as kobject then go ahead and post the code
> >> so it can be used in drivers.
> > 
> > Wait a moment. You are getting something backwards here.
> > 
> > Fact is that the current code is not designed for easy hotunplugging
> > and therefor requires looping.
> > 
> > So _you_ propose a work-around to replace the busy-loop by a sleeping
> > loop with "hope that ....". Hope is the least thing what counts in
> > programming.
> > 
> > Now a reviewer tells you that your idea of replacing the busy-loop by
> > a sleeping in hope loop is flawed, because it does not solve the
> > underlying design problem of the GPIO code. And you get a suggestion
> > how to solve it correctly.
> > 
> > Now you go and request from that reviewer to implement that? That's
> > not how it works.
> > 
> > You sent a flawed patch in the first place and people try to tell you
> > how to do it right. Then it's on you to either go and do it right or
> > at least ask politely for help and pointers.
> > 
> > Thanks,
> > 
> > 	tglx
> > 
> 
> You misunderstood me.
> By "looping in hope that somebody will finally release the chip" I meant the only
> real way to handle a GPIO chip unplugging in the current kernel.
> Which is way worse that preventing new requests, then waiting for existing one to be released.
> And this is exactly what my patch does.
> 
> I understand that it could be simplified by removing redundant code (as Grant Likely had suggested before), and
> moving it to completion interface instead of manipulating a task structure directly, but this doesn't mean
> that the whole GPIO code has to be rewritten just to add one functionality.

BTW, switching to using a kobject != rewriting the whole GPIO code.
kobjects are not all that scary and the biggest impact is adding
kobject get/put operation on the gpio get/release apis.  I don't
expect it to end up being overly complex.

The Documentation/kobject.txt file should offer some insight.

g.
