Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab1EVAso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 20:48:44 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13503 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab1EVAsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 20:48:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsDAPlb2E15LCoegWdsb2JhbACmHxUBARYmJohwuioOhgsElzyHXA
Date: Sun, 22 May 2011 10:48:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: "D. Jansen" <d.g.jansen@googlemail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tytso@mit.edu
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Message-ID: <20110522004833.GY32466@dastard>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <20110520033949.GQ32466@dastard>
 <BANLkTikVLFMX_U6brQ5OALbvJkOGuz6++Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikVLFMX_U6brQ5OALbvJkOGuz6++Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 08:01:17AM +0200, D. Jansen wrote:
> On Fri, May 20, 2011 at 5:39 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, May 19, 2011 at 03:34:46PM +0200, Dennis Jansen wrote:
> >> This is my first proper kernel code proposal so please bear with me!
> >>
> >> =Summary for busy kernel hackers=
> >> Problem: laptop_mode wants to keep applications from waking the hard
> >> disks but fsync calls can "sneak through". (IMHO this is a bug.)
> >>
> >> Proposed solution: Pretend the fsync was executed and successful.
> >> Insert two lines into the fsync and fdatasync calls in fs/sync.c:
> >> if (unlikely(laptop_mode))
> >>    return 0;
> >
> > No, no, no, no, no, no, no, no, no, no.
> >
> > There is _absolutely no justification_ for putting people's data at
> > risk like this.  If you want to do make fsync/fdatasync calls
> > no-ops, then go install libeatmydata on your systems. It's your
> > data, and you make the decision to risk it, not us.
> 
> 1. I thought I (may) make that decision by using laptop mode.

Laptop mode does not change fsync guarantees, so no, you ar enot
making a decision to throw data away when you select laptop mode.

> 2. libeatmydata would _always_ be active.

Your choice, really. Just use it as a preload for your apps that you
want to avoid fsync for.

> 3. A lib doesn't fix the ordering guarantee problem.

A properly implemented filesystem will not have ordering problems
just because fsyncs are not issued.

> 4. It's clear that it's not the right code. (And it is a rfc and my
> first one, too...)
> 
> Any suggestions?

Your problem to solve in userspace. Changing a generic, 
widely used kernel option like this is not allowed, and in general
when there are ways in userspace of playing fast and loose with
data, it's up to the user to do that in userspace, not the kernel...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
