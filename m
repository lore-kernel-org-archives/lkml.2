Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2EWI7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:59:51 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:13896 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751051Ab2EWI7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:59:48 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: Regression on GMA965 - display seems to have slow jump changes in brightness
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        Sean Paul <seanpaul@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, daniel@ffwll.ch,
        jbarnes@virtuousgeek.org
In-Reply-To: <CAJJYPdnoEu6QGuACUn0e10TG3XQQsaM5AqfbhqRbH6pwUQoVwg@mail.gmail.com>
References: <CAJJYPd=JQdzepw818ZP6OmKK4v38--T+ruKBOG_wn2pUmnVaSw@mail.gmail.com> <20120522123058.GB4629@phenom.ffwll.local> <CAJJYPdmcJYT1VTnqbkbybut-_NqpFYsuEEzDb9LO-E+ss=wz-g@mail.gmail.com> <20120522144443.GD4629@phenom.ffwll.local> <CAJJYPdmimcz45qdT0W-iLTyY-U2qCe4fa4+e19adrjMtwd2Ywg@mail.gmail.com> <CAJJYPdkhSOXZeCJN9MDHTgd1hg07zo1ZDXkwwASJ74NojQ=dyQ@mail.gmail.com> <CAOw6vbKOss-h8A2yRRunCKv7RUnD6QV4Pj1Rg8+2YC5qBKL8pQ@mail.gmail.com> <CAJJYPdnoEu6QGuACUn0e10TG3XQQsaM5AqfbhqRbH6pwUQoVwg@mail.gmail.com>
Date: Wed, 23 May 2012 09:59:23 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1337763574_198483@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012 08:59:07 +0200, Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
> 2012/5/23 Sean Paul <seanpaul@chromium.org>:
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

It is more likely that we did not detect a downclock mode before now and
so this is the first time that is being used in anger. (There should be
some telltales in drm.debug dmesg) If you are really, really brave you
can try http://cgit.freedesktop.org/~ickle/linux-2.6/log/?h=fastboot
which only triggers the downclock on a vblank.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
