Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2GPQoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:44:00 -0400
Received: from mail.lang.hm ([64.81.33.126]:34746 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab2GPQn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:43:57 -0400
Date: Mon, 16 Jul 2012 09:43:03 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Borislav Petkov <bp@amd64.org>
cc: Cyrill Gorcunov <gorcunov@openvz.org>, Pekka Enberg <penberg@kernel.org>,
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
In-Reply-To: <20120716082418.GC24327@aftab.osrc.amd.com>
Message-ID: <alpine.DEB.2.02.1207160937330.20176@asgard.lang.hm>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <1342212885.25704.4.camel@lade.trondhjem.org> <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com> <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com> <20120715101434.GA18144@aftab.osrc.amd.com> <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com> <20120715211848.GA21167@aftab.osrc.amd.com> <20120715214819.GA1990@moon>
 <alpine.DEB.2.02.1207151459480.20176@asgard.lang.hm> <20120716082418.GC24327@aftab.osrc.amd.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Borislav Petkov wrote:

> On Sun, Jul 15, 2012 at 03:09:12PM -0700, david@lang.hm wrote:
>> On Mon, 16 Jul 2012, Cyrill Gorcunov wrote:
>>
>>> Replying to David's message (sorry for delay) I fear having a bunch of
>>> miniconfig files will end up in a mess. Maybe (maybe (!) I don't know since
>>> I've no time at moment to read kconfig code and I'm not sure if this
>>> is right direction at all) it would worth to add some new keyword to
>>> kconfig language, say "profile", which would tag symbol to a category
>>> if needed, and these categories included into profiles automatically.
>>> On the other hands this might end up in a mess as well.
>>
>> I have a couple problems with the approach of modifying the existing
>> kconfig files
>>
>> 1. how does it handle the case when a profile wants something one
>> way and the admin wants it another way
>
> Select the profile and then fixup the config the normal way.
>
> If what the admin wants is incompatible with the profile, admin doesn't
> select the profile.
>
>>   the example is the fedora default wanting SELINUX and I want some
>> other LSM
>
> Currently, if you run fedora and want something that's not enabled, you
> recompile your kernel too, right?

The problem is that you can't select the Fedora profile and then unselect 
SELINUX, so the profile will do you no good.

It's not a matter of needing to recompile or not, it's a mattter that when 
you want to recompile, you want to be able to easily select the 
infrastructure pieces that the distro needs to operate, without also 
getting their huge selection of 'other' things.

>> 2. since it requires making changes in the upstream kernel source, the
>> number of people who can make these changes is small.
>
> I think that's moot since you either select the profile or you don't.
>
>> 3. since all these changes go into the upstream kernel source, changes
>> to these profiles are going to be visible churn (think of the issues
>> with the defconfigs for ARM a couple of years ago)
>
> AFAICT, those changes will be needed only for a new distro release and
> that happens twice a year, tops.
>
>> 4. the complexity of tagging all possible profiles is very high.
>
> That's why we start simple.
>
>> Even if you limit the profiles to "Linux Distros", how many different
>> distros are there? Do you really want to have to start arguing over
>> which distros are large enough to get their profile added to the
>> upstream kernel source?
>
> That's a valid question; its answer could be defined arbitrarily.
>
> <joshing>
> Let's say all distros which make money - more than a certain large
> amount - are allowed. :-)
> </joshing>

So that would eliminate all linux distros except for Red Hat Enterprise 
and Suse (including eliminating opensuse and fedora), somehow I don't 
think that would produce the benefit that Linus was looking for.

>> If instead we go with something along the lines of the miniconf
>> approach, the picture looks very different
>>
>> 1. this approach only sets things one time, after that the person
>> doing the compile is free to change anything.
>
> ...
>
> Sorry, I don't see the simplification: you need to rebuild your kernel
> anyway and before you rebuild it, you can do all the changes you want.
> So either you select a profile or you load a miniconfig, it doesn't
> really matter how you do it?

Yes, you have to recompile in any case.

The difference is that with a profile, the profile must be in the kernel 
source, and you will have problems if you want to start with the profile 
and then tweak something.

with miniconfig, you can have locally defined configs, you can combine 
multiple configs, and the configs define a starting point, but you can 
then override them if you want to.

David Lang
