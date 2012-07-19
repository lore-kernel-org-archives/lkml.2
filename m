Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab2GSVEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:04:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:58701 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2GSVEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:04:34 -0400
Date: Thu, 19 Jul 2012 14:04:11 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Josh Boyer <jwboyer@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
In-Reply-To: <20120719183645.GH8469@zod.bos.redhat.com>
Message-ID: <alpine.DEB.2.02.1207191357360.20176@asgard.lang.hm>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <20120713210240.GG1707@redhat.com> <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com> <20120719152618.GD16873@home.goodmis.org> <20120719154521.GC8469@zod.bos.redhat.com>
 <1342714088.12353.33.camel@gandalf.stny.rr.com> <20120719171918.GD8469@zod.bos.redhat.com> <1342719222.12353.58.camel@gandalf.stny.rr.com> <20120719175649.GF8469@zod.bos.redhat.com> <1342721620.12353.75.camel@gandalf.stny.rr.com>
 <20120719183645.GH8469@zod.bos.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2012, Josh Boyer wrote:

> On Thu, Jul 19, 2012 at 02:13:40PM -0400, Steven Rostedt wrote:
>> On Thu, 2012-07-19 at 13:56 -0400, Josh Boyer wrote:
>>
>>> Distros aren't stationary things.
>>
>> Exactly my point.
>>
>>>   I mean, some of them certainly aim
>>> for that goal, but userspace and kernels get upgraded all the time.  So
>>> if this distro-Kconfig file is provided by some package _other_ than the
>>> kernel the distros are going to have a bit of a hassle keeping track of
>>> it.
>>
>> How about a directory called /usr/share/Linux/Kconfig.d/
>>
>> Then have anything installed that needs to work correctly put in its
>> minimum (must have) requirement configs of the kernel.
>>
>> Say you are running Debian, and decide to try out systemd. If you set up
>> your system to run that it would add a file called:
>>
>> /usr/share/Linux/Kconfig.d/systemd.conf
>>
>> or something, and this would select things like CGROUPS and the like. We
>> could make the kernel build select all, or individual files in this
>> directory. All for the 'make my distro work' or individual for a 'I want
>> part of my distro to work' option.
>
> That sounds like a pretty good idea, aside from the fact that now your
> config is determined by 1) what is currently installed on your system
> and 2) people that don't maintain the kernel.
>
> 1 is obviously a great thing once you have a stable working set of
> packages you use daily, but wouldn't it kind of suck to have to rebuild
> the kernel just to install some new package?  I mean... say you wanted
> to now use an NFS mount, but you didn't have nfs-utils previously
> installed.  So you install it, and it plops the kconfig file in
> /usr/share but oops, you have to rebuild the kernel and reboot because
> that module isn't built.  Of course I'm extrapolating possibly the worst
> usage case here, but it will still happen.

the alturnative to this is what? compile everything just in case you need 
it some time in the future?

we already have some tools (vmware) that check for the proper kernel 
config when they startup, and if the appropriate stuff isn't there they 
ask for the root password and compile the modules.

> 2... yeah.  I don't really know if that is going to pan out, but I am
> ever hopeful.  I'd be mostly concerned with people that are coding
> userspace applications using every whiz-bang kernel feature.  Or not
> paying attention at all to the kernel after the initial file creation
> and the options going stale (don't follow renames, etc).

it would be determined by the distro maintainers who maintain the kernel 
config for that distro.

David Lang
