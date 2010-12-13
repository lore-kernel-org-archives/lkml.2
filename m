Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab0LMRPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:15:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297Ab0LMRPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:15:00 -0500
Date: Mon, 13 Dec 2010 19:14:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tools/virtio: virtio_test tool
Message-ID: <20101213171432.GB7182@redhat.com>
References: <20101129170431.GA4027@redhat.com>
 <20101129171637.GC4027@redhat.com>
 <201012061523.03108.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012061523.03108.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 03:23:02PM +1030, Rusty Russell wrote:
> On Tue, 30 Nov 2010 03:46:37 am Michael S. Tsirkin wrote:
> > This is the userspace part of the tool: it includes a bunch of stubs for
> > linux APIs, somewhat simular to linuxsched. This makes it possible to
> > recompile the ring code in userspace.
> > 
> > A small test example is implemented combining this with vhost_test
> > module.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Hi Michael,
> 
>   I'm not sure what the point is of this work?  You'll still need to
> benchmark on real systems, but it's not low-level enough to measure
> things like cache misses.

The point is to be able to create easy to test workloads:
(just running the single test included here produces a
 result that seems repeatable to a high degree)
while still staying as close as possible to what we might expect in real
life.

I also want to be able to measure just the overhead of the ring,
without involving block or network core in guest and host.

In other words, it's a synthetic benchmark.

> I'm assuming you're thinking of playing with layout to measure cache
> behaviour.

In one example, using this test I saw that different publish
used index layouts don't seem to behave at all differently.

But I also saw that the extra pointer hasing
added by my publish used index patches did add
measureable overhead.

Plan to look into that.

>  I was thinking of a complete userspace implementation

The disadvantage is that any work done there needs to be
redone in real life, though. And implementation details often matter.
What I did let me actually use the virtio/vhost code that we have and see how
it performs.

> where
> either it was run under cachegrind, or each access was wrapped to allow
> tracking of cachelines to give an exact measure of cache movement

perf stat not good enough?

> under
> various scenarios (esp. ring mostly empty, ring in steady state, ring
> mostly full).

Yes, I do want to add tests to stress various scenarios.

> 
> Cheers,
> Rusty.


-- 
MST
