Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934985Ab1ETDj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:39:57 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:23414 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934959Ab1ETDjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:39:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlAFANbf1U15LCoegWdsb2JhbACYHI18FQEBFiYlxkMOhgsElzyHXA
Date: Fri, 20 May 2011 13:39:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: d.g.jansen@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tytso@mit.edu
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Message-ID: <20110520033949.GQ32466@dastard>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 03:34:46PM +0200, Dennis Jansen wrote:
> This is my first proper kernel code proposal so please bear with me!
> 
> =Summary for busy kernel hackers=
> Problem: laptop_mode wants to keep applications from waking the hard
> disks but fsync calls can "sneak through". (IMHO this is a bug.)
> 
> Proposed solution: Pretend the fsync was executed and successful.
> Insert two lines into the fsync and fdatasync calls in fs/sync.c:
> if (unlikely(laptop_mode))
>    return 0;

No, no, no, no, no, no, no, no, no, no.

There is _absolutely no justification_ for putting people's data at
risk like this.  If you want to do make fsync/fdatasync calls
no-ops, then go install libeatmydata on your systems. It's your
data, and you make the decision to risk it, not us.

And BTW, I just added your name to my "ignore fileystem/data
corruption bug reports from these people" list, because that's
exactly where you'll end up with if you follow this path.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
