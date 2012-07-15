Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab2GOWKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 18:10:32 -0400
Received: from mail.lang.hm ([64.81.33.126]:56442 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2GOWK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 18:10:29 -0400
Date: Sun, 15 Jul 2012 15:09:12 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: Borislav Petkov <bp@amd64.org>, Pekka Enberg <penberg@kernel.org>,
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
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration
 for distro issues
In-Reply-To: <20120715214819.GA1990@moon>
Message-ID: <alpine.DEB.2.02.1207151459480.20176@asgard.lang.hm>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <1342212885.25704.4.camel@lade.trondhjem.org> <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com> <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com> <20120715101434.GA18144@aftab.osrc.amd.com> <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com> <20120715211848.GA21167@aftab.osrc.amd.com> <20120715214819.GA1990@moon>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Cyrill Gorcunov wrote:

> Replying to David's message (sorry for delay) I fear having a bunch of
> miniconfig files will end up in a mess. Maybe (maybe (!) I don't know since
> I've no time at moment to read kconfig code and I'm not sure if this
> is right direction at all) it would worth to add some new keyword to
> kconfig language, say "profile", which would tag symbol to a category
> if needed, and these categories included into profiles automatically.
> On the other hands this might end up in a mess as well.

I have a couple problems with the approach of modifying the existing 
kconfig files

1. how does it handle the case when a profile wants something one way and 
the admin wants it another way

   the example is the fedora default wanting SELINUX and I want some other 
LSM

2. since it requires making changes in the upstream kernel source, the 
number of people who can make these changes is small.

3. since all these changes go into the upstream kernel source, changes to 
these profiles are going to be visible churn (think of the issues with the 
defconfigs for ARM a couple of years ago)

4. the complexity of tagging all possible profiles is very high.

   Even if you limit the profiles to "Linux Distros", how many different 
distros are there? Do you really want to have to start arguing over which 
distros are large enough to get their profile added to the upstream kernel 
source?


If instead we go with something along the lines of the miniconf approach, 
the picture looks very different

1. this approach only sets things one time, after that the person doing 
the compile is free to change anything.

2. since the changes are a local file, separate from the upstream source, 
issues like who can provide the config, what distros will accept it, 
complexity in having many different options, etc all vanish

3. by simply combining miniconfig files, you can combine sets of 
pre-defined options

David Lang
