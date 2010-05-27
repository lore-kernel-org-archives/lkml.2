Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab0E0I6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:58:39 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:49901 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab0E0I6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BkUFSW7yVQ55rtXeqI+fQQadSTWqMpTE3Qt9lRy9zwTfFFbEkRd4OuUnRKNJcDJFEF
         vQMvPPifI/wWcIpLD3q0JeQMxW5o/AwRNJNGMOmxlVVdVwtsmAaDxsdFKBvvWn3d10zh
         UmvXJneD/bml6gd5Q8BrNN4qp43yKZVFKagGw=
MIME-Version: 1.0
In-Reply-To: <20100526145452.685337db@schatten.dmk.lab>
References: <1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526122932.GB1990@nokia.com>
	<20100526143323.7c6f8705@schatten.dmk.lab>
	<20100526123532.GA2629@nokia.com>
	<20100526145452.685337db@schatten.dmk.lab>
Date: Thu, 27 May 2010 11:58:35 +0300
Message-ID: <AANLkTik2ZkNABlqIptjxDGtJoXpNo578oQle0vVtAvUp@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: felipe.balbi@nokia.com, Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 3:54 PM, Florian Mickler <florian@mickler.org> wrote:
> It really comes down to a policy decision by the distribution maker.
> And I don't think kernel upstream should be the one to force one way or
> the other. So merging this patch set will allow android to continue
> their work _on mainline_ while everybody else can continue as before.
>
> All points about the impact on the kernel have already been raised. So
> you should be happy there.
>
> Nonetheless, I really think the kernel needs to allow for the android
> way of power saving. It misses out on a big feature and a big user-base
> if not.

Let's get rid of hypothetical uses in the future: suspend blockers is
_only_ used by Android user-space. Nobody else has expressed any
intention of using them.

> Also I expect there to be synergies between android development and
> mainline kernel development _only_ if android development can use
> mainline kernel.

That's like saying "there can only be synergies between linux real
time and mainline _only_ if RT development can use mainline".

I can give you my experience at Nokia... can you use mainline on any
of the Maemo devices? No. You have to patch the kernel heavily, to be
able to kind-of run the official user-space, or you have to use a
different user-space.

Does that prevent synergies? No. As Brian Swetland and Daniel Walker
already expressed before; you can run mainline kernel with debian on
Android phones.

It would be nice to run Android user-space, or parts of it on mainline
kernels, but if it's not possible, that's a deficiency on Android's
design; Maemo/Moblin/Meego are good players in the linux ecosystem so
you can re-use parts of the system on typical desktops (in fact many
are coming from there), and there are community distributions re-using
those parts and running just fine on mainline kernels.

Sure, it would be easier for Android developers if all their crap was
in the mainline, but even then there are no guarantees of anything.
Just like any other linux phone, you'll probably need to add patches
for 3D drivers, DSP, or other hardware acceleration, missing
board-specfic patches, and bunch of hacks.

So if you have to add all those patches anyway, what's the problem of
having to add the suspend block patches?

Why do some Android developers think they can be the exception and
have patches merged in the core of linux _only_ for their specific
user-space, and their specific drivers?

If you separate suspend blockers from Android, and judge them on their
technical merit, I don't see a single person saying this is a good
idea, we'll switch all our user-space to use them.

-- 
Felipe Contreras
