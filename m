Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab2FCN00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 09:26:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44055 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2FCN0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 09:26:25 -0400
Date: Sun, 3 Jun 2012 15:27:47 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Paulo Zanoni <przanoni@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Lots of i915/drm spew on 3.4
Message-ID: <20120603132731.GA4696@phenom.ffwll.local>
Mail-Followup-To: Paulo Zanoni <przanoni@gmail.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>
References: <20120530213128.GA10407@redhat.com>
 <CAKMK7uE7RtzFd1RR4gyOaStSEisircr7gC7sz5BwVNiy2EtV+g@mail.gmail.com>
 <20120530215848.GB19223@redhat.com>
 <20120530222651.GA22449@redhat.com>
 <CA+gsUGRwNh9Zc9bA9JjdHSxpq7djLzqXdhAjcyCb2VcL7H+G_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+gsUGRwNh9Zc9bA9JjdHSxpq7djLzqXdhAjcyCb2VcL7H+G_w@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 11:43:21AM -0300, Paulo Zanoni wrote:
> 2012/5/30 Dave Jones <davej@redhat.com>:
> > On Wed, May 30, 2012 at 05:58:48PM -0400, Dave Jones wrote:
> >  > On Wed, May 30, 2012 at 11:51:54PM +0200, Daniel Vetter wrote:
> >  >  > On Wed, May 30, 2012 at 11:31 PM, Dave Jones <davej@redhat.com> wrote:
> >  >  > > On this hardware:
> >  >  > >
> >  >  > > 00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated Graphics Controller (rev 02)
> >  >  > >
> >  >  > > I get this every boot with Linus current tree (up to af56e0aa35f3ae2a4c1a6d1000702df1dd78cb76)
> >  >  >
> >  >  > Just a quick question, is this a regression?
> >  >
> >  > seems so, I don't see it on 3.3
> >  >
> >  >  > If so, can you please
> >  >  > attach the output of xrandr --verbose from a noisy and a quite kernel
> >  >  > (otherwise just please attach it from this noisy kernel).
> >  >
> >  > this machine runs headless, so has no X installed right now, I'll get it in a while.
> >
> > Attached.
> >
> 
> Just a little more information: you have a lot of connector properties
> because for some reason the driver thinks you have TV1, TV2 and TV3.
> Each TV connector has a lot of properties... With kernel 3.3 you have
> only TV1 and TV2. Maybe instead of increasing the maximum property
> count we should try to investigate why there's a new TV connector in
> the new kernel (and maybe this is also not a bug/regression...).

I've merged a patch from Chris to detect additional sdvo TV outputs:

commit a0b1c7a5197293d6206b245b45edc3f508aadab6
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Sep 30 22:56:41 2011 +0100

    drm/i915/sdvo: Include YRPB as an additional TV output type

So that explains that hopefully.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
