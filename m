Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab2GNMnj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 08:43:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48126 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2GNMnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 08:43:37 -0400
Date: Sat, 14 Jul 2012 16:43:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
Message-ID: <20120714124332.GA4093@moon>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 03:12:05PM +0300, Pekka Enberg wrote:
> On Sat, Jul 14, 2012 at 1:37 PM, Borislav Petkov <bp@alien8.de> wrote:
> > On Fri, Jul 13, 2012 at 11:41:21PM +0200, richard -rw- weinberger wrote:
> >> On Fri, Jul 13, 2012 at 10:54 PM, Myklebust, Trond
> >> <Trond.Myklebust@netapp.com> wrote:
> >> > We could at least make selection of a minimal set of drivers for the
> >> > more common virtualised platforms a lot easier.
> >> > Right now, you need to hunt through 30+ different menus in order to find
> >> > what you need to run in a basic KVM virtual machine...
> >>
> >> Yes, every time I build a kernel to be used on KVM I forget something. :-\
> >>
> >> We could introduce a section in Kconfig which contains selections for
> >> common use cases.
> >> E.g. as Linus requested for minimal distro requirements but also
> >> selections for various common
> >> guest configurations.
> >
> > +1.
> >
> > Same experience with building a kvm kernel so I couldn't agree more.
> 
> We have "make kvmconfig" in the KVM tool tree that pretty much does
> that automatically. There's nothing tools/kvm specific about it so I
> guess you could merge that separately.

Yup, "make kvmconfig" does things right but I guess a general mechanism
might be preferred here :)

Look, if (at the moment) I'm going to nconfig and virt. section, I see

Virtualization
  Kernel-based Virtual Machine (KVM) support
    KVM for Intel processors support
    KVM for AMD processors support
    Audit KVM MMU
  Host kernel accelerator for virtio net (EXPERIMENTAL)

and everytime I'm here I need to remember where to search for
virtio devices I would like to include into config. Though I
expect to see in this secrion everything related to virtualization
and have a way to turn on virtio-ring and etc.

For example to enable "PCI driver for virtio devices" I need to
go to Device Drivers -> Virtio drivers, while I think it would
be great to have everything virt. related in Virtualization
section.

(note, I know how to enable all this and where to lookup for
 this entries of course, but I guess for regular users it
 would be easier to enable various virt. features if they
 are gathered in one place)

	Cyrill
