Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab2EYVUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:20:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2EYVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:20:46 -0400
Date: Fri, 25 May 2012 23:20:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Anssi Hannula <anssi.hannula@iki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL for v3.5-rc1] media updates for v3.5
In-Reply-To: <4FBFA37E.2060308@redhat.com>
Message-ID: <Pine.LNX.4.64.1205252305500.13353@axis700.grange>
References: <4FBE5518.5090705@redhat.com>
 <CA+55aFyt2OFOsr5uCpQ6nrur4zhHhmWUJrvMgLH_Wy1niTbC6w@mail.gmail.com>
 <4FBEB72D.4040905@redhat.com> <CA+55aFyYQkrtgvG99ZOOhAzoKi8w5rJfRgZQy3Dqs39p1n=FPA@mail.gmail.com>
 <4FBF773B.10408@redhat.com> <4FBF9BE8.3020300@iki.fi> <4FBFA37E.2060308@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:6X/XKRcUPpHy5ZAJl29jLUIn+hppb5NhJIbJ4InNDLm
 n7lOjJp2LlaDf2HD0AqsmcqiKyul2hW8+PkVCCs0a1UQdtEhwJ
 NdNbwMc4xruqdSOaYif8G1RbUneJve5xbsFEfLfanF0qnGRIU2
 F24TpqoVCdcjhpDo8ZO2KCwiRH9sOlWdcG/+CnazWuXlR5aW97
 NLpKAD5xQ0SWHSp6uTVxZveVm+d/Qp6ekmtNH9wEByxCYbEF1K
 aBgmf9gTNYyuK4tpxHf8JCV7naRGT+6Eh9bvbdb44CzZEusqAa
 FrDhsAMbikIIoGp6rbMgjA63rME8gz//c/x1obaB+oxt/kVNrc
 TxJn+jFb1n5rfw/ZFuEvwHXMJlIYzxJx9e7hG6vMfLwxaFBG+n
 jl9YpR1DdpILQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro

On Fri, 25 May 2012, Mauro Carvalho Chehab wrote:

> Em 25-05-2012 11:49, Anssi Hannula escreveu:
> > 25.05.2012 15:12, Mauro Carvalho Chehab kirjoitti:

[snip]

> >> [RFC PATCH] Make tuner/frontend options dependent on EXPERT
> >>
> >> The media CUSTOMISE options are there to allow embedded systems and advanced
> >> users to disable tuner/frontends that are supported by a bridge driver to
> >> be disabled, in order to save some disk space and memory, when compiled builtin.
> >>
> >> However, distros are mistakenly enabling it, causing problems when a
> >> make oldconfig is used.
> >>
> >> Make those options dependent on EXPERT, in order to avoid such annoyance behavior.
> >>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>
> >> diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
> >> index bbf4945..702a3bf 100644
> >> --- a/drivers/media/common/tuners/Kconfig
> >> +++ b/drivers/media/common/tuners/Kconfig
> >> @@ -35,6 +35,7 @@ config MEDIA_TUNER
> >>  config MEDIA_TUNER_CUSTOMISE
> >>  	bool "Customize analog and hybrid tuner modules to build"
> >>  	depends on MEDIA_TUNER
> >> +	depends on EXPERT
> >>  	default y if EXPERT
> >         ^^^^^^^^^^^^^^^^^^^
> > 
> > Hmm, why should CONFIG_EXPERT automatically mean that the tuner modules
> > should be customized? I'd think this shouldn't default to y even with
> > EXPERT.
> > 
> > Not a biggie, just thought I'd point it out :)
> > 
> > (as a sidenote, on Mageia kernels CONFIG_EXPERT is on... didn't check
> > why, could be just historical reasons)
> > 
> >>  	help
> >>  	  This allows the user to deselect tuner drivers unnecessary
> >> diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
> >> index b98ebb2..6d3c2f7 100644
> >> --- a/drivers/media/dvb/frontends/Kconfig
> >> +++ b/drivers/media/dvb/frontends/Kconfig
> >> @@ -1,6 +1,7 @@
> >>  config DVB_FE_CUSTOMISE
> >>  	bool "Customise the frontend modules to build"
> >>  	depends on DVB_CORE
> >> +	depends on EXPERT
> >>  	default y if EXPERT
> > 
> > Ditto.
> > 
> >>  	help
> >>  	  This allows the user to select/deselect frontend drivers for their
> >
> 
> This was added on the changeset b3fc1782c8 (see below). A latter changeset (6a108a14fa3)
> renamed EMBEDDED to EXPERT.
> 
> For embedded systems, it makes more sense to customize the tuners/demods, in order to
> remove drivers that would never be used there. That's the rationale behind this patch.
> 
> >From my side, I don't mind removing the "default y if EXPERT", but, as I don't usually
> work with embedded devices, I don't care much about that. It would be great to hear
> some comments from embedded people about that as well.

My opinion hasn't changed since then. I actually wanted an even larger 
change, but it has been shrunk to what we see below. Hans also wanted to 
reorganise Kconfig, so, I hoped, situation would improve after that, but 
it didn't. And with every new kernel new tuner modules get added, which 
automatically get enabled, so, every time I upgrade to a newer kernel I 
have to make sure to deselect them. This doesn't seem a very optimal 
situation to me. BTW, what is stated below (the commit message is not 
completely mine, it has been edited, Mauro, by you?) is also not always 
true: tuner modules are not autoselected by host cards if customisation 
is on. They simply all default to "m" in this case.

Thanks
Guennadi

> That's said, it is weird that Mageia is using CONFIG_EXPERT. Are they using those
> two Kconfig options enabled as well?
> 
> Regards,
> Mauro
> 
> -
> 
> commit b3fc1782c8b84574e44cf5869c9afa75523e2db8
> Author: Guennadi Liakhovetski <lyakh@extensa5220.grange>
> Date:   Thu Aug 5 18:09:28 2010 -0300
> 
>     V4L/DVB: V4L: do not autoselect components on embedded systems
>     
>     Tuner, DVB frontend and video helper chip drivers are by default
>     autoselected by their respective host cards, this, however, doesn't make
>     much sense on SoC-based systems. Disable autoselection on EMBEDDED
>     systems.
>     
>     Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
> index 409a426..b3ed5da 100644
> --- a/drivers/media/common/tuners/Kconfig
> +++ b/drivers/media/common/tuners/Kconfig
> @@ -34,7 +34,7 @@ config MEDIA_TUNER
>  menuconfig MEDIA_TUNER_CUSTOMISE
>  	bool "Customize analog and hybrid tuner modules to build"
>  	depends on MEDIA_TUNER
> -	default n
> +	default y if EMBEDDED
>  	help
>  	  This allows the user to deselect tuner drivers unnecessary
>  	  for their hardware from the build. Use this option with care
> diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
> index 51d578a..b5f6a04 100644
> --- a/drivers/media/dvb/frontends/Kconfig
> +++ b/drivers/media/dvb/frontends/Kconfig
> @@ -1,7 +1,7 @@
>  config DVB_FE_CUSTOMISE
>  	bool "Customise the frontend modules to build"
>  	depends on DVB_CORE
> -	default N
> +	default y if EMBEDDED
>  	help
>  	  This allows the user to select/deselect frontend drivers for their
>  	  hardware from the build.
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index c70b67d..9d55fef 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -83,7 +83,7 @@ config VIDEO_FIXED_MINOR_RANGES
>  
>  config VIDEO_HELPER_CHIPS_AUTO
>  	bool "Autoselect pertinent encoders/decoders and other helper chips"
> -	default y
> +	default y if !EMBEDDED
>  	---help---
>  	  Most video cards may require additional modules to encode or
>  	  decode audio/video standards. This option will autoselect
> 
> 
> 
> 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
