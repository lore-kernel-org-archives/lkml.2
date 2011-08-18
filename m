Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1HRQbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:31:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48869 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1HRQa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:30:59 -0400
Subject: Re: [PATCH] virtio-blk: Add stats VQ to collect information about
 devices
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4E4D2B6D.1040908@redhat.com>
References: <1313524071-27250-1-git-send-email-levinsasha928@gmail.com>
	 <4E4C481A.5080205@redhat.com> <1313642283.22532.4.camel@lappy>
	 <4E4D2B6D.1040908@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 18 Aug 2011 19:29:44 +0300
Message-ID: <1313684984.30799.20.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 08:10 -0700, Avi Kivity wrote:
> On 08/17/2011 09:38 PM, Sasha Levin wrote:
> > On Wed, 2011-08-17 at 16:00 -0700, Avi Kivity wrote:
> > >  On 08/16/2011 12:47 PM, Sasha Levin wrote:
> > >  >  This patch adds support for an optional stats vq that works similary to the
> > >  >  stats vq provided by virtio-balloon.
> > >  >
> > >  >  The purpose of this change is to allow collection of statistics about working
> > >  >  virtio-blk devices to easily analyze performance without having to tap into
> > >  >  the guest.
> > >  >
> > >  >
> > >
> > >  Why can't you get the same info from the host?  i.e. read sectors?
> >
> > Some of the stats you can collect from the host, but some you can't.
> >
> > The ones you can't include all the timing statistics and the internal
> > queue statistics (read/write merges).
> 
> Surely you can time the actual amount of time the I/O takes?  It doesn't 
> account for the virtio round-trip, but does it matter?
> 
> Why is the merge count important for the host?
> 

I assumed that the time the request spends in the virtio layer is
(somewhat) significant, specially since that this is something that adds
up over time.

Merge count can be useful for several testing scenarios (I'll describe
the reasoning behind this patch below).

> >
> > The idea behind providing all of the stats on the stats vq (which is
> > basically what you see in '/dev/block/[device]/stats') is to give a
> > consistent snapshot of the state of the device.
> >
> >
> 
> What can you do with it?
> 

I was actually planning on submitting another patch that would add
something similar into virtio-net. My plan was to enable collecting
statistics regarding memory, network and disk usage in a simple manner
without accessing guests.

How can this be used? my vision behind it was automation of kernel
testing and benchmarking.

I created a simple set of scripts that does bisection of kernel issues
(which is a combination of 'git bisect run' scripts and a simple
framework that generates /sbin/init used for testing without having to
touch any guests or images.

The scripts builds a simple image which contains only whats required to
test the kernel, and runs the test kernel and test image to determine
whether we hit a 'git bisect good' or 'git bisect bad' automatically.

I was looking to expand it to allow detection of more than just patches
that break things, but also patches that caused a performance hit in a
specific scenario.

-- 

Sasha.

