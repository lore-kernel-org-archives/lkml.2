Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab2GOVsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 17:48:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63010 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2GOVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 17:48:24 -0400
Date: Mon, 16 Jul 2012 01:48:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Borislav Petkov <bp@amd64.org>, Pekka Enberg <penberg@kernel.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, david@lang.hm,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
Message-ID: <20120715214819.GA1990@moon>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
 <20120715101434.GA18144@aftab.osrc.amd.com>
 <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com>
 <20120715211848.GA21167@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120715211848.GA21167@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 11:18:48PM +0200, Borislav Petkov wrote:
> On Sun, Jul 15, 2012 at 01:17:16PM +0300, Pekka Enberg wrote:
> > > Yes, something like KVMTOOL_TEST_ENABLE except not a make target but a
> > > Kconfig option.
> > 
> > It is a config option too - "make kvmconfig" simply enables it.
> 
> Right, so how about something more concrete in this whole discussion:
> 
> Maybe add the KVMTOOL_TEST_ENABLE (maybe rename it to a more fitting
> name like KVM_OPTS or similar) thing to a new toplevel Kconfig menu
> called "Distro and other profiles" or so:
> 
>   │ │     General setup  --->
>   │ │     Distros and other profiles  --->			<---
>   │ │ [*] Enable loadable module support  --->
>   │ │ [*] Enable the block layer  --->
>   │ │     Processor type and features  --->
>  ...
> 
> Btw, which Kconfig option is needed for "-usbdevice tablet" support so
> that the host mouse can be able to send scroll events to the guest qemu
> screen without the need for the qemu screen to capture it so that I need
> to "escape" it everytime I need to return to the host? And can we add it
> to the list of options KVMTOOL_TEST_ENABLE selects?

All this is pretty promising idea for usability I think (plain "Profiles"
is enough if not only distros will be there methink).

Replying to David's message (sorry for delay) I fear having a bunch of
miniconfig files will end up in a mess. Maybe (maybe (!) I don't know since
I've no time at moment to read kconfig code and I'm not sure if this
is right direction at all) it would worth to add some new keyword to
kconfig language, say "profile", which would tag symbol to a category
if needed, and these categories included into profiles automatically.
On the other hands this might end up in a mess as well.
