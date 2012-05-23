Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2EWJJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:09:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60510 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab2EWJJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:09:50 -0400
Date: Wed, 23 May 2012 11:11:09 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, jbarnes@virtuousgeek.org
Subject: Re: Regression on GMA965 - display seems to have slow jump changes
 in brightness
Message-ID: <20120523091109.GI5062@phenom.ffwll.local>
Mail-Followup-To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Sean Paul <seanpaul@chromium.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	intel-gfx@lists.freedesktop.org, jbarnes@virtuousgeek.org
References: <CAJJYPd=JQdzepw818ZP6OmKK4v38--T+ruKBOG_wn2pUmnVaSw@mail.gmail.com>
 <20120522123058.GB4629@phenom.ffwll.local>
 <CAJJYPdmcJYT1VTnqbkbybut-_NqpFYsuEEzDb9LO-E+ss=wz-g@mail.gmail.com>
 <20120522144443.GD4629@phenom.ffwll.local>
 <CAJJYPdmimcz45qdT0W-iLTyY-U2qCe4fa4+e19adrjMtwd2Ywg@mail.gmail.com>
 <CAJJYPdkhSOXZeCJN9MDHTgd1hg07zo1ZDXkwwASJ74NojQ=dyQ@mail.gmail.com>
 <CAOw6vbKOss-h8A2yRRunCKv7RUnD6QV4Pj1Rg8+2YC5qBKL8pQ@mail.gmail.com>
 <CAJJYPdnoEu6QGuACUn0e10TG3XQQsaM5AqfbhqRbH6pwUQoVwg@mail.gmail.com>
 <20120523070728.GC5062@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523070728.GC5062@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:07:28AM +0200, Daniel Vetter wrote:
> On Wed, May 23, 2012 at 08:59:07AM +0200, Zdenek Kabelac wrote:
> > Hmm I've been using i915.lvds_downclock=1 on grub command line, and
> > haven't noticed any visible problems with 3.3 kernel. So I'd rather
> > ask if the problematic patch isn't doing downclocking in a wrong way?
> > Or maybe detection that downclocking is not supported properly is not
> > correct now ?
> 
> Nope, Sean's analysis is pretty much correct, that patch only makes
> downclocking possible in more circumstances. And downclocking can
> certainly explain what you're seeing, the backlight pwm signal is driven
> off the panel dotclock, so if we change that we can very likely cause some
> funny interference. I guess we could frob the backligth control settings
> and adjust them for the change in clockspeed, but the current backlight
> code is a bit a mess. So right now I suggest you just drop that option -
> there are reasons it's not the default ;-)

Quick question: What's the frequency of the brightness change? And how
regular are the changes?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
