Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab1FXNqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:46:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34396 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1FXNqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <4E04912A.4090305@infradead.org>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1106232356530.17688@swampdragon.chaosbits.net>
	<4E04732A.3060305@infradead.org>
	<201106241326.27593.hverkuil@xs4all.nl>
	<BANLkTinXymR_2A2Mr+UbhK63s2xjtK=B=g@mail.gmail.com>
	<4E04912A.4090305@infradead.org>
Date: Fri, 24 Jun 2011 09:45:59 -0400
Message-ID: <BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from include/
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Jesper Juhl <jj@chaosbits.net>,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 9:29 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
>> MythTV has a bunch of these too (mainly so the code can adapt to
>> driver bugs that are fixed in later revisions).  Putting Mauro's patch
>> upstream will definitely cause breakage.
>
> It shouldn't, as ivtv driver version is lower than 3.0.0. All the old bug fixes
> aren't needed if version is >= 3.0.0.
>
> Besides that, trusting on a driver revision number to detect that a bug is
> there is not the right thing to do, as version numbers are never increased at
> the stable kernels (nor distro modified kernels take care of increasing revision
> number as patches are backported there).

The versions are increased at the discretion of the driver maintainer,
usually when there is some userland visible change in driver behavior.
 I assure you the application developers don't *want* to rely on such
a mechanism, but there have definitely been cases in the past where
there was no easy way to detect the behavior of the driver from
userland.

It lets application developers work around things like violations of
the V4L2 standard which get fixed in newer revisions of the driver.
It provides them the ability to put a hack in their code that says "if
(version < X) then this driver feature is broken and I shouldn't use
it."

> In other words, relying on it doesn't work fine.

It's the best (and really only solution) we have today.

>> Also, it screws up the ability for users to get fixes through the
>> media_build tree (unless you are increasing the revision constantly
>> with every merge you do).
>
> Why? Developers don't increase version numbers on every applied patch
> (with is great, as it avoids merge conflicts).

The driver maintainer doesn't *have* to increase the version - he does
it when he thinks it's appropriate.  The point is you are taking that
discretion out of *their* hands, and you yourself are unaware of when
it is actually needed.

You need to stop looking at this from a purist standpoint and think of
how application developers actually use the API.  They need tools like
this to allow them to work around driver bugs while having a source
codebase which operates against different kernels (including kernels
that may still have those bugs).

Sure, in a perfect world where drivers don't have bugs and
applications don't have to run against older kernels, what you are
saying is not illogical.  But then again, we don't live in a perfect
world.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
