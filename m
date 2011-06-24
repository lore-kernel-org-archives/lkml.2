Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab1FXN6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:58:16 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1816 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab1FXN6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:58:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from include/
Date: Fri, 24 Jun 2011 15:54:10 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-tschai; KDE/4.6.2; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jesper Juhl <jj@chaosbits.net>, LKML <linux-kernel@vger.kernel.org>,
        trivial@kernel.org, linux-media@vger.kernel.org,
        ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <4E04912A.4090305@infradead.org> <BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>
In-Reply-To: <BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106241554.10751.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 24, 2011 15:45:59 Devin Heitmueller wrote:
> On Fri, Jun 24, 2011 at 9:29 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> >> MythTV has a bunch of these too (mainly so the code can adapt to
> >> driver bugs that are fixed in later revisions).  Putting Mauro's patch
> >> upstream will definitely cause breakage.
> >
> > It shouldn't, as ivtv driver version is lower than 3.0.0. All the old bug fixes
> > aren't needed if version is >= 3.0.0.
> >
> > Besides that, trusting on a driver revision number to detect that a bug is
> > there is not the right thing to do, as version numbers are never increased at
> > the stable kernels (nor distro modified kernels take care of increasing revision
> > number as patches are backported there).
> 
> The versions are increased at the discretion of the driver maintainer,
> usually when there is some userland visible change in driver behavior.
>  I assure you the application developers don't *want* to rely on such
> a mechanism, but there have definitely been cases in the past where
> there was no easy way to detect the behavior of the driver from
> userland.
> 
> It lets application developers work around things like violations of
> the V4L2 standard which get fixed in newer revisions of the driver.
> It provides them the ability to put a hack in their code that says "if
> (version < X) then this driver feature is broken and I shouldn't use
> it."

Indeed. Ideally we shouldn't need it. But reality is different.

What we have right now works and I see no compelling reason to change the
behavior.

Regards,

	Hans

> > In other words, relying on it doesn't work fine.
> 
> It's the best (and really only solution) we have today.
> 
> >> Also, it screws up the ability for users to get fixes through the
> >> media_build tree (unless you are increasing the revision constantly
> >> with every merge you do).
> >
> > Why? Developers don't increase version numbers on every applied patch
> > (with is great, as it avoids merge conflicts).
> 
> The driver maintainer doesn't *have* to increase the version - he does
> it when he thinks it's appropriate.  The point is you are taking that
> discretion out of *their* hands, and you yourself are unaware of when
> it is actually needed.
> 
> You need to stop looking at this from a purist standpoint and think of
> how application developers actually use the API.  They need tools like
> this to allow them to work around driver bugs while having a source
> codebase which operates against different kernels (including kernels
> that may still have those bugs).
> 
> Sure, in a perfect world where drivers don't have bugs and
> applications don't have to run against older kernels, what you are
> saying is not illogical.  But then again, we don't live in a perfect
> world.
> 
> Devin
> 
> 
