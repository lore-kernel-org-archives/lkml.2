Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2GPIYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:24:39 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34154 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2GPIYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:24:35 -0400
Date: Mon, 16 Jul 2012 10:24:18 +0200
From: Borislav Petkov <bp@amd64.org>
To: david@lang.hm
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
Message-ID: <20120716082418.GC24327@aftab.osrc.amd.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
 <20120715101434.GA18144@aftab.osrc.amd.com>
 <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com>
 <20120715211848.GA21167@aftab.osrc.amd.com>
 <20120715214819.GA1990@moon>
 <alpine.DEB.2.02.1207151459480.20176@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207151459480.20176@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 03:09:12PM -0700, david@lang.hm wrote:
> On Mon, 16 Jul 2012, Cyrill Gorcunov wrote:
> 
> >Replying to David's message (sorry for delay) I fear having a bunch of
> >miniconfig files will end up in a mess. Maybe (maybe (!) I don't know since
> >I've no time at moment to read kconfig code and I'm not sure if this
> >is right direction at all) it would worth to add some new keyword to
> >kconfig language, say "profile", which would tag symbol to a category
> >if needed, and these categories included into profiles automatically.
> >On the other hands this might end up in a mess as well.
> 
> I have a couple problems with the approach of modifying the existing
> kconfig files
> 
> 1. how does it handle the case when a profile wants something one
> way and the admin wants it another way

Select the profile and then fixup the config the normal way.

If what the admin wants is incompatible with the profile, admin doesn't
select the profile.

>   the example is the fedora default wanting SELINUX and I want some
> other LSM

Currently, if you run fedora and want something that's not enabled, you
recompile your kernel too, right?

> 2. since it requires making changes in the upstream kernel source, the
> number of people who can make these changes is small.

I think that's moot since you either select the profile or you don't.

> 3. since all these changes go into the upstream kernel source, changes
> to these profiles are going to be visible churn (think of the issues
> with the defconfigs for ARM a couple of years ago)

AFAICT, those changes will be needed only for a new distro release and
that happens twice a year, tops.

> 4. the complexity of tagging all possible profiles is very high.

That's why we start simple.

> Even if you limit the profiles to "Linux Distros", how many different
> distros are there? Do you really want to have to start arguing over
> which distros are large enough to get their profile added to the
> upstream kernel source?

That's a valid question; its answer could be defined arbitrarily.

<joshing>
Let's say all distros which make money - more than a certain large
amount - are allowed. :-)
</joshing>

> If instead we go with something along the lines of the miniconf
> approach, the picture looks very different
> 
> 1. this approach only sets things one time, after that the person
> doing the compile is free to change anything.

...

Sorry, I don't see the simplification: you need to rebuild your kernel
anyway and before you rebuild it, you can do all the changes you want.
So either you select a profile or you load a miniconfig, it doesn't
really matter how you do it?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
