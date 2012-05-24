Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2EXOVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:21:51 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62436 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab2EXOVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:21:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120523120212.GA17595@phenom.ffwll.local>
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
	<20120523120212.GA17595@phenom.ffwll.local>
Date: Thu, 24 May 2012 16:21:48 +0200
Message-ID: <CAJJYPd=G2bdA+92cWJeMBqHV9FVL1-vRPSYH44+Hh3G8aqa9pg@mail.gmail.com>
Subject: Re: [Intel-gfx] Regression on GMA965 - display seems to have slow
 jump changes in brightness
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, jbarnes@virtuousgeek.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/23 Daniel Vetter <daniel@ffwll.ch>:
> On Wed, May 23, 2012 at 01:48:41PM +0200, Zdenek Kabelac wrote:
>> 2012/5/23 Daniel Vetter <daniel@ffwll.ch>:
>> > On Wed, May 23, 2012 at 09:07:28AM +0200, Daniel Vetter wrote:
>> >> On Wed, May 23, 2012 at 08:59:07AM +0200, Zdenek Kabelac wrote:
>> >> > Hmm I've been using i915.lvds_downclock=1 on grub command line, and
>> >> > haven't noticed any visible problems with 3.3 kernel. So I'd rather
>> >> > ask if the problematic patch isn't doing downclocking in a wrong way?
>> >> > Or maybe detection that downclocking is not supported properly is not
>> >> > correct now ?
>> >>
>> >> Nope, Sean's analysis is pretty much correct, that patch only makes
>> >> downclocking possible in more circumstances. And downclocking can
>> >> certainly explain what you're seeing, the backlight pwm signal is driven
>> >> off the panel dotclock, so if we change that we can very likely cause some
>> >> funny interference. I guess we could frob the backligth control settings
>> >> and adjust them for the change in clockspeed, but the current backlight
>> >> code is a bit a mess. So right now I suggest you just drop that option -
>> >> there are reasons it's not the default ;-)
>> >
>> > Quick question: What's the frequency of the brightness change? And how
>> > regular are the changes?
>> > -Daniel
>>
>>
>> Now when it's obvious it's related to powersaving  - it's probably
>> much easier to explain,
>> that I've been observing those changes when some activity was happing -
>> i.e. opening  picture - and after like 1 second image has flashed, -
>> then I've moved the mouse
>> stopped - and again image has flashed with brightness a bit.
>>
>> The issue would be probably far less noticeable if the period of time
>> of idle GPU would have to be
>> much longer (i.e. in minute range)
>
> Hm, that sounds more like something ugly is happening when we switch
> frequencies as opposed to the different frequency causing interference
> with the backlight. Just to check: You only see a quick flash, then
> brightness is back to normal?

In fact I'm not really noticing the moment it goes back to normal -
I'll notice when it gets darker.
i.e. when I open  picture with  'qiv'  - after a second I notice that
picture becomes a bit darker.
If I do not move with anything - it stays this way.

>
> If that's the case, please try Chris' fastboot branch. vsyncing the
> frequency change might indeed fix this.
>

I've tried to compile, but compilation finished with some errors - so
I've tried to rebase branch on master 3.4 - tried to resolve some
error - but probably in a wrong thus resulted kernel given me just
black screen when X has been initialized.  So I'll try to remove some
config options and I'll try to rebuild original fastboot branch later.

Zdenek
