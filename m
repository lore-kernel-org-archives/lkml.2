Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab2EXOjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:39:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52016 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab2EXOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:39:51 -0400
Date: Thu, 24 May 2012 16:41:09 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sean Paul <seanpaul@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, jbarnes@virtuousgeek.org
Subject: Re: [Intel-gfx] Regression on GMA965 - display seems to have slow
 jump changes in brightness
Message-ID: <20120524144109.GB5078@phenom.ffwll.local>
Mail-Followup-To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Sean Paul <seanpaul@chromium.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	intel-gfx@lists.freedesktop.org, jbarnes@virtuousgeek.org
References: <20120522144443.GD4629@phenom.ffwll.local>
 <CAJJYPdmimcz45qdT0W-iLTyY-U2qCe4fa4+e19adrjMtwd2Ywg@mail.gmail.com>
 <CAJJYPdkhSOXZeCJN9MDHTgd1hg07zo1ZDXkwwASJ74NojQ=dyQ@mail.gmail.com>
 <CAOw6vbKOss-h8A2yRRunCKv7RUnD6QV4Pj1Rg8+2YC5qBKL8pQ@mail.gmail.com>
 <CAJJYPdnoEu6QGuACUn0e10TG3XQQsaM5AqfbhqRbH6pwUQoVwg@mail.gmail.com>
 <20120523070728.GC5062@phenom.ffwll.local>
 <20120523091109.GI5062@phenom.ffwll.local>
 <CAJJYPdmmFrUB=SPq5dyLxnDH=q0hwVcGvKCtHpNMVv8CfdomFw@mail.gmail.com>
 <20120523120212.GA17595@phenom.ffwll.local>
 <CAJJYPd=G2bdA+92cWJeMBqHV9FVL1-vRPSYH44+Hh3G8aqa9pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJJYPd=G2bdA+92cWJeMBqHV9FVL1-vRPSYH44+Hh3G8aqa9pg@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 04:21:48PM +0200, Zdenek Kabelac wrote:
> 2012/5/23 Daniel Vetter <daniel@ffwll.ch>:
> > On Wed, May 23, 2012 at 01:48:41PM +0200, Zdenek Kabelac wrote:
> >> 2012/5/23 Daniel Vetter <daniel@ffwll.ch>:
> >> > On Wed, May 23, 2012 at 09:07:28AM +0200, Daniel Vetter wrote:
> >> >> On Wed, May 23, 2012 at 08:59:07AM +0200, Zdenek Kabelac wrote:
> >> >> > Hmm I've been using i915.lvds_downclock=1 on grub command line, and
> >> >> > haven't noticed any visible problems with 3.3 kernel. So I'd rather
> >> >> > ask if the problematic patch isn't doing downclocking in a wrong way?
> >> >> > Or maybe detection that downclocking is not supported properly is not
> >> >> > correct now ?
> >> >>
> >> >> Nope, Sean's analysis is pretty much correct, that patch only makes
> >> >> downclocking possible in more circumstances. And downclocking can
> >> >> certainly explain what you're seeing, the backlight pwm signal is driven
> >> >> off the panel dotclock, so if we change that we can very likely cause some
> >> >> funny interference. I guess we could frob the backligth control settings
> >> >> and adjust them for the change in clockspeed, but the current backlight
> >> >> code is a bit a mess. So right now I suggest you just drop that option -
> >> >> there are reasons it's not the default ;-)
> >> >
> >> > Quick question: What's the frequency of the brightness change? And how
> >> > regular are the changes?
> >> > -Daniel
> >>
> >>
> >> Now when it's obvious it's related to powersaving  - it's probably
> >> much easier to explain,
> >> that I've been observing those changes when some activity was happing -
> >> i.e. opening  picture - and after like 1 second image has flashed, -
> >> then I've moved the mouse
> >> stopped - and again image has flashed with brightness a bit.
> >>
> >> The issue would be probably far less noticeable if the period of time
> >> of idle GPU would have to be
> >> much longer (i.e. in minute range)
> >
> > Hm, that sounds more like something ugly is happening when we switch
> > frequencies as opposed to the different frequency causing interference
> > with the backlight. Just to check: You only see a quick flash, then
> > brightness is back to normal?
> 
> In fact I'm not really noticing the moment it goes back to normal -
> I'll notice when it gets darker.
> i.e. when I open  picture with  'qiv'  - after a second I notice that
> picture becomes a bit darker.
> If I do not move with anything - it stays this way.
> 
> >
> > If that's the case, please try Chris' fastboot branch. vsyncing the
> > frequency change might indeed fix this.
> >
> 
> I've tried to compile, but compilation finished with some errors - so
> I've tried to rebase branch on master 3.4 - tried to resolve some
> error - but probably in a wrong thus resulted kernel given me just
> black screen when X has been initialized.  So I'll try to remove some
> config options and I'll try to rebuild original fastboot branch later.

Hm, maybe attach your .config and yell at Chris a bit to fix up his
branch.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
