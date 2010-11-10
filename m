Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0KJVPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:15:47 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45792 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab0KJVPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:15:46 -0500
Date: Wed, 10 Nov 2010 14:15:40 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Maciej Szmigiero <mhej@o2.pl>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Ben Nizette <bn@niasdigital.com>
Subject: Re: [GPIO]implement sleeping GPIO chip removal
Message-ID: <20101110211540.GA7063@angua.secretlab.ca>
References: <4CD6F049.10102@o2.pl>
 <20101110050947.GC4110@angua.secretlab.ca>
 <4CDABA03.2050000@o2.pl>
 <alpine.LFD.2.00.1011102134350.2900@localhost6.localdomain6>
 <4CDB0834.4080101@o2.pl>
 <alpine.LFD.2.00.1011102203500.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011102203500.2900@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 10:07:05PM +0100, Thomas Gleixner wrote:
> Can you please use a mail client which does proper line breaks at 78 ?
> 
> On Wed, 10 Nov 2010, Maciej Szmigiero wrote:
> > You misunderstood me.
> 
> No, I didnt.
> 
> > By "looping in hope that somebody will finally release the chip" I
> > meant the only real way to handle a GPIO chip unplugging in the
> > current kernel.  Which is way worse that preventing new requests,
> > then waiting for existing one to be released.  And this is exactly
> > what my patch does.
> 
> That still does not make it a good solution.
> 
> > I understand that it could be simplified by removing redundant code
> > (as Grant Likely had suggested before), and moving it to completion
> > interface instead of manipulating a task structure directly, but
> > this doesn't mean that the whole GPIO code has to be rewritten just
> > to add one functionality.
> 
> It's not about rewriting, it's about fixing the problem in the right
> way and not just hacking around it.
> 
> If we see a shortcoming like this, we fix it and do not magically work
> around it.

+1

Thomas is right.  kobject reference counting is the correct solution.
Nack on this approach.

g.

