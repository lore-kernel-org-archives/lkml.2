Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab0GAWgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:36:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57219 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387Ab0GAWgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:36:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=h/SSW76uAg+plprVlCrv2VF8fj3FhHNByveD0zo7we2BvpKLB2lq+/XuMu5lWIVSvq
         s5PKwo2rZsgQhde+wTApL3px8dzk8cjRhTBSB0PNw4iq8IGz1QMfUAcLdh2bTByKCVFg
         kCE1Cn/PqnSfj6234lJPlz8XM2J90s79xO46c=
MIME-Version: 1.0
In-Reply-To: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
Date: Fri, 2 Jul 2010 08:36:44 +1000
Message-ID: <AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>
Subject: Re: Closed source userspace graphics drivers with an open source 
	kernel component
From: Dave Airlie <airlied@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 8:10 AM, Dave Airlie <airlied@gmail.com> wrote:
> Now this is just my opinion as maintainer of the drm, and doesn't
> reflect anyone or any official policy, I've also no idea if Linus
> agrees or not.
>
> We are going to start to see a number of companies in the embedded
> space submitting 3D drivers for mobile devices to the kernel. I'd like
> to clarify my position once so they don't all come asking the same
> questions.
>
> If you aren't going to create an open userspace driver (either MIT or
> LGPL) then don't waste time submitting a kernel driver to me.
>
> My reasons are as follows, the thing is you can probably excuse some
> of these on a point by point basis, but you need to justify why closed
> userspace on all points.
>
> a) licensing, Alan Cox pointed this out before, if you wrote a GPL
> kernel driver, then wrote a closed userspace on top, you open up a
> while world of derived work issues. Can the userspace operate on a
> non-GPL kernel without major modifications etc. This is a can of worms
> I'd rather not enter into, and there are a few workarounds.
>
> b) verifying the sanity of the userspace API.
> 1. Security: GPUs can do a lot of damage if left at home alone, since
> mostly you are submitting command streams unverified into the GPU and
> won't tell us what they mean, there is little way we can work out if
> the GPU is going to over-write my passwd file to get 5 fps more in
> quake. Now newer GPUs have at least started having MMUs, but again
> we've no idea if that is the only way they work without docs or a lot
> of trust.
>
> 2. General API suitability and versioning. How do we check that API is
> sane wrt to userspace, if we can't verify the userspace. What happens
> if the API has lots of 32/64 compat issues or things like that, and
> when we fix them the binary userspace breaks? How do we know, how do
> we test etc. What happens if a security issue forces us to break the
> userspace API? how do we fix the userspace driver and test to confirm?
>
> c) supplying docs in lieu of an open userspace
> If you were to fully document the GPU so we could verify the
> security/api aspects it leaves us in the position of writing our own
> driver. Now writing that driver on top of the current kernel driver
> would probably limit any innovation, and most people would want to
> write a new kernel driver from scratch. Now we end up with two drivers
> fighting, how do we pick which one to load at boot? can we ever do a
> generic distro kernel for that device (assuming ARM ever solves that
> issue).
>
> I've also noticed a trend to just reinvent the whole wheel instead of
> writing a drm/kms driver and having that as the API, again maintainer
> nightmares are made of this.
>
> Dave.

Oh and (one other thought)

d) you are placing the maintenance burden in the wrong place

So you've upstreamed the kernel bits, kept the good userspace bits to
yourselfs, are stroking them on your lap like some sort of Dr Evil,
now why should the upstream kernel maintainers take the burden when
you won't actually give them the stuff to really make their hardware
work? This goes for nvidia type situations as well, the whole point is
to place the maintainer burden at the feet of the people causing the
problems in an effort to make them change. Allowing even an hour of
that burden to be transferred upstream, means more profit for them,
but nothing in return for us.

Dave.
