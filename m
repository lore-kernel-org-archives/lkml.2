Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2GMWdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 18:33:55 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:16788 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2GMWdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 18:33:53 -0400
Date: Sat, 14 Jul 2012 00:33:51 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
In-Reply-To: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1207140014070.10676@swampdragon.chaosbits.net>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Linus Torvalds wrote:

> So this has long been one of my pet configuration peeves: as a user I
> am perfectly happy answering the questions about what kinds of
> hardware I want the kernel to support (I kind of know that), but many
> of the "support infrastructure" questions are very opaque, and I have
> no idea which of the them any particular distribution actually depends
> on.
> 
> And it tends to change over time. For example, F14 (iirc) started
> using TMPFS and TMPFS_POSIX_ACL/XATTR for /dev. And starting in F16,
> the initrd setup requires DEVTMPFS and DEVTMPFS_MOUNT. There's been
> several times when I started with my old minimal config, and the
> resulting kernel would boot, but something wouldn't quite work right,
> and it can be very subtle indeed.
> 
> Similarly, the distro ends up having very particular requirements for
> exactly *which* security models it uses and needs, and they tend to
> change over time. And now with systemd, CGROUPS suddenly aren't just
> esoteric things that no normal person would want to use, but are used
> for basic infrastructure. And I remember being surprised by OpenSUSE
> suddenly needing the RAW table support for netfilter, because it had a
> NOTRACK rule or something.
> 
> The point I'm slowly getting to is that I would actually love to have
> *distro* Kconfig-files, where the distribution would be able to say
> "These are the minimums I *require* to work". So we'd have a "Distro"
> submenu, where you could pick the distro(s) you use, and then pick
> which release, and we'd have something like
> 
>  - distro/Kconfig:
> 
>     config DISTRO_REQUIREMENTS
>         bool "Pick minimal distribution requirements"
> 
>     choice DISTRO
>         prompt "Distribution"
>         depends on DISTRO_REQUIREMENTS
> 
>     config FEDORA
>     config OPENSUSE
>     config UBUNTU
>     ...
> 
>     endchoice
> 
[...]

We are going to end up with a million+ (or something like that) "config 
<RANDOM_FOO_DISTRO>" options that are going to have to be kept up-to-date 
regularly...
Do we really want that?
Maybe we do, maybe we don't - I'm not saying anything either way - just 
pointing it out.

I like the general idea - let a user pick the "make my distro work" option 
and then tweak from there. But, with hundreds (thousands?) of distroes out 
there, is it realy doable? Will we be able to keep things updated 
properly?

Perhaps a better aproach (and this is going to be controversial, so I'll 
put on my flame-repelling underwear now) would be to severely limit the 
number of available options.
KConfig is a mess (IMHO) - there's no telling what a given Linux kernel 
will support on any given distro on any given arch - there's no known 
mimimum.
How about we start cutting down on the options and start saying "a Linux 
system will provide feature x and y - always ...".
Stuff like (and I'm just pulling random stuff out here) - ASLR, seccomp, 
250HZ minimum etc etc.. We could cut the KConfig options down to 10% of 
what they are now if we just made a few (hard) choices about some things 
that would always be there that everyone could count on.  If people want 
to deviate from the default minimum, sure, let them, but put it under 
*custom*, *embedded*, *specialized distro*, *you know what you are doing* 
menu options.
Configurabillity is good, but only to a certain degree - I think we could 
bennefit from removing a *lot* of options and instead just decreeing that 
"a linux system has this"..


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

