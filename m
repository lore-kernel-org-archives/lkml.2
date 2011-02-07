Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1BGXGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:06:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51841 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab1BGXGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:06:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Date: Tue, 8 Feb 2011 00:05:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-embedded@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201102072300.03986.rjw@sisk.pl> <20110207222350.GA24804@core.coreip.homeip.net>
In-Reply-To: <20110207222350.GA24804@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102080005.40448.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 07, 2011, Dmitry Torokhov wrote:
> On Mon, Feb 07, 2011 at 11:00:03PM +0100, Rafael J. Wysocki wrote:
> > On Monday, February 07, 2011, Dmitry Torokhov wrote:
> > > On Mon, Feb 07, 2011 at 10:15:59PM +0100, Rafael J. Wysocki wrote:
> > > > On Monday, February 07, 2011, Mark Brown wrote:
> > > > > 
> > > > > Yeah, but some people seem very keen on removing the pointers to the PM
> > > > > ops entirely when CONFIG_PM is disabled which means that you end up with
> > > > > varying idioms for what you do with the PM ops as stuff gets ifdefed
> > > > > out.  Then again I'm not sure anything would make those people any
> > > > > happier.
> > > > 
> > > > I really think we should do things that makes sense rather that worry about
> > > > who's going to like or dislike it (except for Linus maybe, but he tends to like
> > > > things that make sense anyway).  At this point I think the change I suggested
> > > > makes sense, because it (a) simplifies things and (b) follows the quite common
> > > > practice which is to make PM callbacks depend on CONFIG_PM.
> > > 
> > > Many people make these callback dependent on PM not because it makes
> > > much sense but because it is possible to do so. However, aside of
> > > randconfig compile testing, nobody really tests drivers that implement
> > > PM in the !CONFIG_PM setting.
> > 
> > That I can agree with, but I'm not sure whether it is an argument against
> > the patch I've just posted or for it?
> 
> More of an observation for your (b) justification. I'd probably force
> CONFIG_PM to always 'y'w while we weeding references to it from
> drivers...

We simply can't force CONFIG_PM to 'y', because some platforms want it to be 'n'.

OTOH, if CONFIG_PM = CONFIG_PM_SLEEP||CONFIG_PM_RUNTIME, we can just leave the
#ifdefs as they are and simply avoid adding new ones, or use CONFIG_PM for all
PM callbacks.

Thanks,
Rafael
