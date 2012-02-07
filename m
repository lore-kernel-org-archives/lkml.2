Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab2BGUyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:54:36 -0500
Received: from ozlabs.org ([203.10.76.45]:54626 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509Ab2BGUye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:54:34 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>
Cc: Gleb Natapov <gleb@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
In-Reply-To: <4F2F9E89.7090607@redhat.com>
References: <4F2AB552.2070909@redhat.com> <20120205093723.GQ23536@redhat.com> <4F2E4F8B.8090504@redhat.com> <20120205095153.GA29265@redhat.com> <4F2EAFF6.7030006@codemonkey.ws> <4F2F9E89.7090607@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 08 Feb 2012 04:42:58 +1030
Message-ID: <87vcnih5qt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Feb 2012 11:34:01 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 02/05/2012 06:36 PM, Anthony Liguori wrote:
> > If userspace had a way to upload bytecode to the kernel that was
> > executed for a PIO operation, it could either pass the operation to
> > userspace or handle it within the kernel when possible without taking
> > a heavy weight exit.
> >
> > If the bytecode can access variables in a shared memory area, it could
> > be pretty efficient to work with.
> >
> > This means that the kernel never has to deal with specific in-kernel
> > devices but that userspace can accelerator as many of its devices as
> > it sees fit.
> 
> I would really love to have this, but the problem is that we'd need a
> general purpose bytecode VM with binding to some kernel APIs.  The
> bytecode VM, if made general enough to host more complicated devices,
> would likely be much larger than the actual code we have in the kernel now.

We have the ability to upload bytecode into the kernel already.  It's in
a great bytecode interpreted by the CPU itself.

If every user were emulating different machines, LPF this would make
sense.  Are they?  Or should we write those helpers once, in C, and
provide that for them.

Cheers,
Rusty.
