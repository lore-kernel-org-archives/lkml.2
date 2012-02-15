Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2BPBwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 20:52:02 -0500
Received: from ozlabs.org ([203.10.76.45]:39875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab2BPBvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 20:51:15 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
In-Reply-To: <4F3BB59D.2020505@redhat.com>
References: <4F2AB552.2070909@redhat.com> <20120205093723.GQ23536@redhat.com> <4F2E4F8B.8090504@redhat.com> <20120205095153.GA29265@redhat.com> <4F2EAFF6.7030006@codemonkey.ws> <4F2F9E89.7090607@redhat.com> <87vcnih5qt.fsf@rustcorp.com.au> <4F3BB59D.2020505@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 16 Feb 2012 09:38:16 +1030
Message-ID: <87mx8jbspr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012 15:39:41 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 02/07/2012 08:12 PM, Rusty Russell wrote:
> > > I would really love to have this, but the problem is that we'd need a
> > > general purpose bytecode VM with binding to some kernel APIs.  The
> > > bytecode VM, if made general enough to host more complicated devices,
> > > would likely be much larger than the actual code we have in the kernel now.
> >
> > We have the ability to upload bytecode into the kernel already.  It's in
> > a great bytecode interpreted by the CPU itself.
> 
> Unfortunately it's inflexible (has to come with the kernel) and open to
> security vulnerabilities.

It doesn't have to come with the kernel, but it does require privs.  And
the bytecode itself might be invulnerable, the services it will call
will be, so it's not clear it'll be a win, given the reduced
auditability.

The grass is not really greener, and getting there involves many fences.

> > If every user were emulating different machines, LPF this would make
> > sense.  Are they?  
> 
> They aren't.
> 
> > Or should we write those helpers once, in C, and
> > provide that for them.
> 
> There are many of them: PIT/PIC/IOAPIC/MSIX tables/HPET/kvmclock/Hyper-V
> stuff/vhost-net/DMA remapping/IO remapping (just for x86), and some of
> them are quite complicated.  However implementing them in bytecode
> amounts to exposing a stable kernel ABI, since they use such a vast
> range of kernel services.

We could think about regularizing and enumerating the various in-kernel
helpers, and give userspace a generic mechanism for wiring them up.
That would surely be the first step towards bytecode anyway.

But the current device assignment ioctls make me think that this
wouldn't be simple or neat.

Cheers,
Rusty.
