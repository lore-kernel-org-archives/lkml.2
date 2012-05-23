Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816Ab2EWLso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:48:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42702 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab2EWLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:48:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120523091109.GI5062@phenom.ffwll.local>
References: <CAJJYPd=JQdzepw818ZP6OmKK4v38--T+ruKBOG_wn2pUmnVaSw@mail.gmail.com>
	<20120522123058.GB4629@phenom.ffwll.local>
	<CAJJYPdmcJYT1VTnqbkbybut-_NqpFYsuEEzDb9LO-E+ss=wz-g@mail.gmail.com>
	<20120522144443.GD4629@phenom.ffwll.local>
	<CAJJYPdmimcz45qdT0W-iLTyY-U2qCe4fa4+e19adrjMtwd2Ywg@mail.gmail.com>
	<CAJJYPdkhSOXZeCJN9MDHTgd1hg07zo1ZDXkwwASJ74NojQ=dyQ@mail.gmail.com>
	<CAOw6vbKOss-h8A2yRRunCKv7RUnD6QV4Pj1Rg8+2YC5qBKL8pQ@mail.gmail.com>
	<CAJJYPdnoEu6QGuACUn0e10TG3XQQsaM5AqfbhqRbH6pwUQoVwg@mail.gmail.com>
	<20120523070728.GC5062@phenom.ffwll.local>
	<20120523091109.GI5062@phenom.ffwll.local>
Date: Wed, 23 May 2012 13:48:41 +0200
Message-ID: <CAJJYPdmmFrUB=SPq5dyLxnDH=q0hwVcGvKCtHpNMVv8CfdomFw@mail.gmail.com>
Subject: Re: Regression on GMA965 - display seems to have slow jump changes in brightness
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, jbarnes@virtuousgeek.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/23 Daniel Vetter <daniel@ffwll.ch>:
> On Wed, May 23, 2012 at 09:07:28AM +0200, Daniel Vetter wrote:
>> On Wed, May 23, 2012 at 08:59:07AM +0200, Zdenek Kabelac wrote:
>> > Hmm I've been using i915.lvds_downclock=1 on grub command line, and
>> > haven't noticed any visible problems with 3.3 kernel. So I'd rather
>> > ask if the problematic patch isn't doing downclocking in a wrong way?
>> > Or maybe detection that downclocking is not supported properly is not
>> > correct now ?
>>
>> Nope, Sean's analysis is pretty much correct, that patch only makes
>> downclocking possible in more circumstances. And downclocking can
>> certainly explain what you're seeing, the backlight pwm signal is driven
>> off the panel dotclock, so if we change that we can very likely cause some
>> funny interference. I guess we could frob the backligth control settings
>> and adjust them for the change in clockspeed, but the current backlight
>> code is a bit a mess. So right now I suggest you just drop that option -
>> there are reasons it's not the default ;-)
>
> Quick question: What's the frequency of the brightness change? And how
> regular are the changes?
> -Daniel


Now when it's obvious it's related to powersaving  - it's probably
much easier to explain,
that I've been observing those changes when some activity was happing -
i.e. opening  picture - and after like 1 second image has flashed, -
then I've moved the mouse
stopped - and again image has flashed with brightness a bit.

The issue would be probably far less noticeable if the period of time
of idle GPU would have to be
much longer (i.e. in minute range)

Zdenek
