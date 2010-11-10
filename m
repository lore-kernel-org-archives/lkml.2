Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab0KJXPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:15:39 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43246 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab0KJXPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:15:36 -0500
Date: Thu, 11 Nov 2010 08:15:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Greg KH <gregkh@suse.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, Maciej Szmigiero <mhej@o2.pl>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Ben Nizette <bn@niasdigital.com>
Subject: Re: [GPIO]implement sleeping GPIO chip removal
Message-ID: <20101110231507.GA6758@linux-sh.org>
References: <4CD6F049.10102@o2.pl> <20101110050947.GC4110@angua.secretlab.ca> <4CDABA03.2050000@o2.pl> <alpine.LFD.2.00.1011102134350.2900@localhost6.localdomain6> <4CDB0834.4080101@o2.pl> <alpine.LFD.2.00.1011102203500.2900@localhost6.localdomain6> <20101110211540.GA7063@angua.secretlab.ca> <20101110224516.GA19567@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110224516.GA19567@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 02:45:16PM -0800, Greg KH wrote:
> On Wed, Nov 10, 2010 at 02:15:40PM -0700, Grant Likely wrote:
> > On Wed, Nov 10, 2010 at 10:07:05PM +0100, Thomas Gleixner wrote:
> > > > I understand that it could be simplified by removing redundant code
> > > > (as Grant Likely had suggested before), and moving it to completion
> > > > interface instead of manipulating a task structure directly, but
> > > > this doesn't mean that the whole GPIO code has to be rewritten just
> > > > to add one functionality.
> > > 
> > > It's not about rewriting, it's about fixing the problem in the right
> > > way and not just hacking around it.
> > > 
> > > If we see a shortcoming like this, we fix it and do not magically work
> > > around it.
> > 
> > +1
> > 
> > Thomas is right.  kobject reference counting is the correct solution.
> > Nack on this approach.
> 
> Only use a kobject if you want to be in the sysfs hierarchy (which I
> don't think you want to do here.)  If you want proper reference
> counting, use a 'struct kref' instead.
> 
This is actually an interesting problem. The gpiolib code presently has
its own hand-rolled sysfs support, which is entirely optional. If someone
is going to go through and do some refactoring anyways it would be
worthwile to see how much tidying up using a kobject would permit. 
kobject-based refcounting could in effect be used like kref-refcounting
with the sysfs interface disabled, too.
