Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2DRXay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:30:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40884 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab2DRXaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:30:52 -0400
Date: Wed, 18 Apr 2012 16:30:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Andres Salomon <dilinger@queued.net>,
        Valentin Rothberg <valentinrothberg@googlemail.com>,
        devel@driverdev.osuosl.org, Jon Nettleton <jon.nettleton@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Jordan Crouse <jordan@cosmicpenguin.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] staging: olpc_dcon.c: checkpatch.pl and style fixups
Message-ID: <20120418233049.GC9419@kroah.com>
References: <alpine.LNX.2.00.1204150049270.15578@swampdragon.chaosbits.net>
 <20120414192638.31fa501d@debxo>
 <alpine.LNX.2.00.1204152338270.18522@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204152338270.18522@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 11:39:32PM +0200, Jesper Juhl wrote:
> On Sat, 14 Apr 2012, Andres Salomon wrote:
> 
> > On Sun, 15 Apr 2012 00:53:04 +0200 (CEST)
> > Jesper Juhl <jj@chaosbits.net> wrote:
> > 
> > > This patch removes the few checkpatch.pl issues that are currently
> > > reported for this file.
> > > 
> > > It makes these changes:
> > > 
> > > 1. Quoted strings that were broken over multiple lines are put on a
> > >    single line for easier grep'ability.
> > > 
> > > 2. Add missing level to a printk().
> > > 
> > > 3. A few casts have had their space between the cast and variable
> > >    removed.
> > > 
> > 
> > These first three look fine.
> > 
> > 
> > > 4. Two msleep() calls with times <= 20 have been changed to
> > >    usleep_range() calls instead since msleep(<=20) may sleep for 20ms
> > >    (on 100Hz kernels for instance).
> > >    Picking a value for the lower bound of the range was easy, that was
> > >    just the value passed to msleep(). As for picking the upper bound
> > >    of the sleep I just went with two times the lower bound, for no
> > >    other reason than the fact that in both cases that value was <=20ms
> > >    and the end result will in any case be closer to the intention than
> > >    a 20ms sleep.
> > 
> > 
> > That msleep(1) was replaced with a longer msleep and fewer dcon_read
> > attempts in OLPC's XO-1.75 kernel.  The msleep(10) should probably be
> > a shorter usleep (though we'd need to test it).  In general, this
> > stuff was done to work around bugs in the dcon, and the timing of these
> > bugs appears to differ (probably due to smbus timing) between the
> > various OLPC platforms - XO-1 (x86 amd geode), XO-1.5 (x86 via), and
> > XO-1.75 (arm armada 610). 
> > 
> > Given that, I'd prefer to leave these alone and figure out the proper
> > values later (with lots of testing).  Mind resubmitting with the
> > msleep changes removed?
> > 
> Not at all :-)
> 
> How's this?

Not good, it still does more than one thing at once, please break up
into individual parts and resend.

greg k-h
