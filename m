Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab2EWHGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:06:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39043 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2EWHGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:06:09 -0400
Date: Wed, 23 May 2012 09:07:28 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Sean Paul <seanpaul@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, daniel@ffwll.ch,
        jbarnes@virtuousgeek.org
Subject: Re: Regression on GMA965 - display seems to have slow jump changes
 in brightness
Message-ID: <20120523070728.GC5062@phenom.ffwll.local>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJJYPdnoEu6QGuACUn0e10TG3XQQsaM5AqfbhqRbH6pwUQoVwg@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 08:59:07AM +0200, Zdenek Kabelac wrote:
> 2012/5/23 Sean Paul <seanpaul@chromium.org>:
> > On Tue, May 22, 2012 at 6:15 PM, Zdenek Kabelac
> > <zdenek.kabelac@gmail.com> wrote:
> >> 2012/5/22 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> >>> 2012/5/22 Daniel Vetter <daniel@ffwll.ch>:
> >>>> On Tue, May 22, 2012 at 04:36:30PM +0200, Zdenek Kabelac wrote:
> >>>>> 2012/5/22 Daniel Vetter <daniel@ffwll.ch>:
> >>>>> > On Tue, May 22, 2012 at 02:08:46PM +0200, Zdenek Kabelac wrote:
> >>>>> >> Hi
> >>>>> >>
> >>>>> >> I've updated to 3.4 kernel, and now I'm noticing slight changes in
> >>>>> >> brightness on colorful images.
> >>>>> >> It seems the change is mostly visibly on  'darker' images i.e. it's
> >>>>> >> not really visible on white background.
> >>>>> >>
> >>>>> >> When I reboot back to 3.3  kernel - brightness changes are gone - so I
> >>>>> >> do not suspect hw fault of my T61 display.
> >>>>> >> I guess once in past there has been already such bug, so this problem
> >>>>> >> seems to me like reintroducing the same
> >>>>> >> problem again.
> >>>>> >>
> >>>>> >> xorg-x11-server-Xorg-1.12.1-1.fc18.x86_64
> >>>>> >> with SNA intel driver build from git repo.
> >>>>> >> T61, 965GM
> >>>>> >>
> >>>>> >> Is this a know issue ?
> >>>>> >> Is bisect needed ?
> >>>>> >
> >>>>> > You're the first one to report things, so a bisect would be highly
> >>>>> > appreciated. Also I'm a bit confused about what you mean by 'changing
> >>>>> > brightness'. Can you please try to explain this a bit more?
> >>>>> >
> >>>>>
> >>>>> I've some default gnome picture like this one:
> >>>>> https://lh6.googleusercontent.com/-96ZhFbfLX_M/ThHsm0ZxBgI/AAAAAAAAFQQ/3ApjzYgulso/s400/gnome-3-login-screen.png
> >>>>>
> >>>>> When I watch the picture for some period of time  I'm noticing slight
> >>>>> changes in the picture brightness looking like small change in LUT
> >>>>> table or something like that.
> >>>>> If the picture is white I'm not noticing any change.
> >>>>> (Initially I've thought my display dies - but reboot to 3.3 fixed the
> >>>>> issue immediately).
> >>>>
> >>>> "for some period", does that mean it takes you a while to notice the
> >>>> changes (because they're tiny), or are the changes happend just rather slowly?
> >>>>
> >>>
> >>> Deviation in picture is not huge - but gets noticeable by my eyes and
> >>> it's annoying,
> >>> it's like several seconds between each minor change.
> >>>
> >>> If I've monotone background in i.e. text editor  the change is
> >>> practically not visibible,
> >>> but if watch some digicam photos full screen they are quite obvious.
> >>>
> >>> Not sure if that has any influence (not tested without)  I'm using
> >>> some icc profile
> >>> ('xcalib') to get away from blue of IBM display.
> >>>
> >>>>> Is there any suspecting patch for this chipset I should try to revert ?
> >>>>
> >>>> Tbh I have no idea. If there's no changes when the picture is white, it
> >>>> can't be the backlight, we haven't frobbed around with the gamma stuff and
> >>>> temporal dithering is disabled, too. If you can bisect this it would
> >>>> greatly help.
> >>>
> >>> ok, I'll play this game in the evening if there is nothing obvious.
> >>>
> >>
> >> And we have a winner - cec2f356d59d9e070413e5966a3c5a1af136d948
> >>
> >
> > Hmm, seems like your display doesn't like to be downclocked, or rather
> > you don't like it to be downclocked :) The reason this patch triggered
> > it is because it does a better job of finding a compatible clock. You
> > can disable lvds downclocking on the kernel command line by setting
> > i915.lvds_downclock=0
> >
> 
> Hmm I've been using i915.lvds_downclock=1 on grub command line, and
> haven't noticed any visible problems with 3.3 kernel. So I'd rather
> ask if the problematic patch isn't doing downclocking in a wrong way?
> Or maybe detection that downclocking is not supported properly is not
> correct now ?

Nope, Sean's analysis is pretty much correct, that patch only makes
downclocking possible in more circumstances. And downclocking can
certainly explain what you're seeing, the backlight pwm signal is driven
off the panel dotclock, so if we change that we can very likely cause some
funny interference. I guess we could frob the backligth control settings
and adjust them for the change in clockspeed, but the current backlight
code is a bit a mess. So right now I suggest you just drop that option -
there are reasons it's not the default ;-)
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
