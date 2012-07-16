Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2GPWWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:22:07 -0400
Received: from mail.lang.hm ([64.81.33.126]:54144 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab2GPWWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:22:05 -0400
Date: Mon, 16 Jul 2012 15:21:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Borislav Petkov <bp@amd64.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
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
In-Reply-To: <CA+55aFw7zdyPpDEdpDbYWc-Z++v_kDQHD3Z+-QwPszh+9bU+tQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1207161451020.32545@asgard.lang.hm>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <1342212885.25704.4.camel@lade.trondhjem.org> <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com> <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com> <20120715101434.GA18144@aftab.osrc.amd.com> <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com> <20120715211848.GA21167@aftab.osrc.amd.com> <20120715214819.GA1990@moon>
 <alpine.DEB.2.02.1207151459480.20176@asgard.lang.hm> <20120716082418.GC24327@aftab.osrc.amd.com> <alpine.DEB.2.02.1207160937330.20176@asgard.lang.hm> <CA+55aFwwmMbFr4HXTFxF_MeM_n8bfiXfPPgCALTOc1HvidVt1Q@mail.gmail.com> <alpine.DEB.2.02.1207161222380.32545@asgard.lang.hm>
 <CA+55aFw7zdyPpDEdpDbYWc-Z++v_kDQHD3Z+-QwPszh+9bU+tQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Linus Torvalds wrote:

> On Mon, Jul 16, 2012 at 12:26 PM,  <david@lang.hm> wrote:
>>
>> Some of the proposed ways to implement the minimum distro kernel would not
>> allow you to override the distro defaults because they would be implemented
>> by setting dependancies, not by selecting options that you as the user could
>> then unselect.
>
> The sanest thing to do is just a list of "select" statements. And in
> any case it would have to depend on the "distro config" entry, so EVEN
> THEN you could just create the Kconfig file, then edit out the distro
> config thing, and then do whatever you want.
>
> So I don't see why you're arguing. Even if it is very much a "if you
> select the FEDORA_X kconfig option, that will automatically force all
> those other options on", I don't see why you are so upset. Just set
> it, generate your kconfig, and then edit to file to NOT set the distro
> config. Then you can do whatever the hell you want.
>
> What I'm upset about is simply the fact that EVEN IF your arguments
> were valid (and I don't think they are: see above for trivial fix) I
> think your arguments are bogus, for the simple reason that what you
> ask for isn't even what the whole "distro minconfig" is at all about.
> It's about normal users who absolutely DO NOT want to edit the config.
> People who want to say "I know I have intel/amd/nvidia graphics,
> standard USB, and no CD-ROM drive". They couldn't care *less* about
> SELINUX, and in fact that very issue is why we should have this.
>
> Anybody who says "I want to run Fedora without SELINUX because I do my
> own security development" is by *definition* not relevant to the whole
> feature.

Don't mistake the example for the feature. the SELINUX thing is just an 
example. As Alan Cox commented, taking a distro config and disabling one 
thing is a common troubleshooting request from kernel developers.

I am not that familiar with the internals of kconfig, but my understanding 
was that if you select feature X that then turns on A, B, and C, if you 
then edit the .config file to remove feature X features A, B, and C will 
be turned off the next time you do a make *config. If this is not the 
case, then it's not as horrible as I was thinking.

However, there's still the question of how many different variations of 
how many different distros are you going to accept into the upstream 
kernel. How many different versions of Fedora are you going to be willing 
to have in the menu? This seems to me to be the defconfig problem 
multiplied by many distros and many versions of each distro. If we can 
eliminate this combinational explosion by referencing something outside of 
the kernel tree, it seems to me that it's a big win.

As Alan Cox put it in code

> make distroconfig
>       [cp /etc/system-kconfig(.$ARCH?) .config
>        make oldconfig]
> 
> make menuconfig (if you want to customise)

with the distros providing /etc/system-kconfig files seems far more 
scalable as well as far more flexible than either setting up a lot of 
dependancies for new tags or adding a field to every option to make it 
part of some profile.

This approach works both for the users who just want to say "I know I have 
intel/amd/nvidia graphics, standard USB, and no CD-ROM drive", for the 
users who know a bit more, but want to start with a known point, and for 
the production sysadmins who want to use the same mechanism for other 
purposes (standardizing builds for systems as kernel versions move 
forward)

David Lang
