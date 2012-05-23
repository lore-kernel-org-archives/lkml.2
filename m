Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab2EWMBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 08:01:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33946 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759803Ab2EWMBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 08:01:47 -0400
Date: Wed, 23 May 2012 14:03:03 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Sean Paul <seanpaul@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, jbarnes@virtuousgeek.org
Subject: Re: [Intel-gfx] Regression on GMA965 - display seems to have slow
 jump changes in brightness
Message-ID: <20120523120212.GA17595@phenom.ffwll.local>
Mail-Followup-To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Sean Paul <seanpaul@chromium.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	intel-gfx@lists.freedesktop.org, jbarnes@virtuousgeek.org
References: <20120522123058.GB4629@phenom.ffwll.local>
 <CAJJYPdmcJYT1VTnqbkbybut-_NqpFYsuEEzDb9LO-E+ss=wz-g@mail.gmail.com>
 <20120522144443.GD4629@phenom.ffwll.local>
 <CAJJYPdmimcz45qdT0W-iLTyY-U2qCe4fa4+e19adrjMtwd2Ywg@mail.gmail.com>
 <CAJJYPdkhSOXZeCJN9MDHTgd1hg07zo1ZDXkwwASJ74NojQ=dyQ@mail.gmail.com>
 <CAOw6vbKOss-h8A2yRRunCKv7RUnD6QV4Pj1Rg8+2YC5qBKL8pQ@mail.gmail.com>
 <CAJJYPdnoEu6QGuACUn0e10TG3XQQsaM5AqfbhqRbH6pwUQoVwg@mail.gmail.com>
 <20120523070728.GC5062@phenom.ffwll.local>
 <20120523091109.GI5062@phenom.ffwll.local>
 <CAJJYPdmmFrUB=SPq5dyLxnDH=q0hwVcGvKCtHpNMVv8CfdomFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJJYPdmmFrUB=SPq5dyLxnDH=q0hwVcGvKCtHpNMVv8CfdomFw@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 01:48:41PM +0200, Zdenek Kabelac wrote:
> 2012/5/23 Daniel Vetter <daniel@ffwll.ch>:
> > On Wed, May 23, 2012 at 09:07:28AM +0200, Daniel Vetter wrote:
> >> On Wed, May 23, 2012 at 08:59:07AM +0200, Zdenek Kabelac wrote:
> >> > Hmm I've been using i915.lvds_downclock=1 on grub command line, and
> >> > haven't noticed any visible problems with 3.3 kernel. So I'd rather
> >> > ask if the problematic patch isn't doing downclocking in a wrong way?
> >> > Or maybe detection that downclocking is not supported properly is not
> >> > correct now ?
> >>
> >> Nope, Sean's analysis is pretty much correct, that patch only makes
> >> downclocking possible in more circumstances. And downclocking can
> >> certainly explain what you're seeing, the backlight pwm signal is driven
> >> off the panel dotclock, so if we change that we can very likely cause some
> >> funny interference. I guess we could frob the backligth control settings
> >> and adjust them for the change in clockspeed, but the current backlight
> >> code is a bit a mess. So right now I suggest you just drop that option -
> >> there are reasons it's not the default ;-)
> >
> > Quick question: What's the frequency of the brightness change? And how
> > regular are the changes?
> > -Daniel
> 
> 
> Now when it's obvious it's related to powersaving  - it's probably
> much easier to explain,
> that I've been observing those changes when some activity was happing -
> i.e. opening  picture - and after like 1 second image has flashed, -
> then I've moved the mouse
> stopped - and again image has flashed with brightness a bit.
> 
> The issue would be probably far less noticeable if the period of time
> of idle GPU would have to be
> much longer (i.e. in minute range)

Hm, that sounds more like something ugly is happening when we switch
frequencies as opposed to the different frequency causing interference
with the backlight. Just to check: You only see a quick flash, then
brightness is back to normal?

If that's the case, please try Chris' fastboot branch. vsyncing the
frequency change might indeed fix this.

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
