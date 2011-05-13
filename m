Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab1EMHUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:20:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:57991 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab1EMHUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:20:23 -0400
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
From: Peter Zijlstra <peterz@infradead.org>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
In-Reply-To: <BANLkTimsvvWqcGanJs688hytLx1_jb0itw@mail.gmail.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
	 <20110502061411.GA16682@elte.hu>
	 <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
	 <20110504111355.GC5914@elte.hu>
	 <BANLkTi=rnOZb-E35SC5B9Xb3SXMwFZi=Fg@mail.gmail.com>
	 <1305191300.2914.263.camel@laptop>
	 <BANLkTimsvvWqcGanJs688hytLx1_jb0itw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 13 May 2011 09:19:47 +0200
Message-ID: <1305271187.17430.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 10:30 -0700, Nikhil Rao wrote:
> On Thu, May 12, 2011 at 2:08 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2011-05-05 at 18:29 -0700, Nikhil Rao wrote:
> >> > It's a cost/benefit analysis and for 32-bit systems the benefits seem to be
> >> > rather small, right?
> >> >
> >>
> >> Yes, that's right. The benefits for 32-bit systems do seem to be limited.
> >
> > deep(er) hierarchies on 32 bits still require this, it would be good to
> > verify that the cgroup mess created by the insanity called libvirt will
> > indeed work as expected.
> >
> 
> I went through the libvirt docs and from what I understand, it creates
> a hierarchy which is about 3 levels deep and has as many leaf nodes as
> guest VMs.

That sounds about right with what I remember people telling me
earlier ;-)

> Taking this graphic from
> http://berrange.com/posts/2009/12/03/using-cgroups-with-libvirt-and-lxckvm-guests-in-fedora-12/
> 
> $ROOT
>  |
>  +-  libvirt    (all virtual machines/containers run by libvirtd)
>        |
>        +- lxc   (all LXC containers run by libvirtd)
>        |   |
>        |   +-  guest1    (LXC container called 'guest1')
>        |   +-  guest2    (LXC container called 'guest2')
>        |   +-  guest3    (LXC container called 'guest3')
>        |   +-  ...       (LXC container called ...)
>        |
>        +- qemu  (all QEMU/KVM containers run by libvirtd)
>            |
>            +-  guest1    (QENU machine called 'guest1')
>            +-  guest2    (QEMU machine called 'guest2')
>            +-  guest3    (QEMU machine called 'guest3')
>            +-  ...       (QEMU machine called ...)
> 
> Assuming the tg shares given to libvirt, lxc and qemu containers are
> the defaults, the load balancer should be able to deal with the
> current resolution on 32-bit. Back of the envelope calculations using
> that approach I mentioned earlier (i.e. log_b(1024/NR_CPU)) says you
> need > 64 VMs before you run out of resolution. I think that might be
> too much to expect from a 8-cpu 32-bit machine ;-)

Quite so, get a real machine etc.. ;-) But then, there's always some
weird people out there, but I think we can tell them to run a 64bit
kernel.
