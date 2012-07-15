Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2GOXHV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 19:07:21 -0400
Received: from mail.lang.hm ([64.81.33.126]:54366 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab2GOXHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 19:07:16 -0400
Date: Sun, 15 Jul 2012 16:06:26 -0700 (PDT)
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
In-Reply-To: <20120715222244.GB1990@moon>
Message-ID: <alpine.DEB.2.02.1207151552100.20176@asgard.lang.hm>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <1342212885.25704.4.camel@lade.trondhjem.org> <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com> <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com> <20120715101434.GA18144@aftab.osrc.amd.com> <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com> <20120715211848.GA21167@aftab.osrc.amd.com> <20120715214819.GA1990@moon>
 <alpine.DEB.2.02.1207151459480.20176@asgard.lang.hm> <20120715222244.GB1990@moon>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Cyrill Gorcunov wrote:

> On Sun, Jul 15, 2012 at 03:09:12PM -0700, david@lang.hm wrote:
>>
>> 3. by simply combining miniconfig files, you can combine sets of
>> pre-defined options
>
> Wait, David, I'm lost. These miniconfigs should live somewhere on
> my home directory (if they are out of mainline tree)?

the distro provided miniconfig files should live in a "known location" 
(like the distro specific scripts for "make install", but I'm saying that 
we should be able to use this same mechanism to include locally generated 
files.

combining external files doesn't need to be the job of the kernel kconfig 
infrastructure either. There could be external scripts that take one or 
more distro provided files and one or more local files and combine them 
for the kconfig infrastructure.

For a distro, I could see their build farm using this as well, with a file 
organization along the lines of

base config
arch specific options (one per arch)
generic drivers (USB devices, etc)

This sort of thing would help reduce the chances of there being unexpected 
differences between the different architecture builds.

this can be done without having to modify the existing kconfig stuff at 
all (by using make oldconfig), but it's likely that a little bit of 
support from kconfig could make creating these miniconifg files much 
easier.

Linus started off wanting the core requirements, other people want to 
duplicate the full distro kernel, others want everything but the drivers, 
others want to substatute a list of driver options that their local 
systems need, etc. by using separate files that are external to the 
kconfig files in the kernel.org source tree, I think that all these people 
can be satisfied without an explosion of complexity in the source tree.

David Lang
