Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab1EYAAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 20:00:09 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:21265 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933278Ab1EYAAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 20:00:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvADAJRD3E15LCoegWdsb2JhbACmKBUBARYmJcgbDoYNBJdRh2E
Date: Wed, 25 May 2011 10:00:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: "D. Jansen" <d.g.jansen@googlemail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Message-ID: <20110525000003.GJ32466@dastard>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <BANLkTikVLFMX_U6brQ5OALbvJkOGuz6++Q@mail.gmail.com>
 <20110522004833.GY32466@dastard>
 <201105231012.06928.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105231012.06928.oneukum@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 10:12:06AM +0200, Oliver Neukum wrote:
> Am Sonntag, 22. Mai 2011, 02:48:33 schrieb Dave Chinner:
> > On Fri, May 20, 2011 at 08:01:17AM +0200, D. Jansen wrote:
> > > On Fri, May 20, 2011 at 5:39 AM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > > 1. I thought I (may) make that decision by using laptop mode.
> > 
> > Laptop mode does not change fsync guarantees, so no, you ar enot
> > making a decision to throw data away when you select laptop mode.
> 
> You do however decide to sync less often, resulting in a potentially
> larger loss of data.
> 
> > > 3. A lib doesn't fix the ordering guarantee problem.
> > 
> > A properly implemented filesystem will not have ordering problems
> > just because fsyncs are not issued.
> 
> But user space will have this problem. A single task's sequence of
> write(); fsync(); write(); does give an implicit guarantee of ordering
> to user space.

Oh, you're talking about application level write ordering. IO
"ordering" in filesystem speak is about guaranteeing the order of
data vs metadata writes for ensuring consistency after a crash
(e.g. ext3/4 default "data=ordered" mode). that's what I was
refering to, not anythign to do with applications.

Besides, having to work out how to handle subtle application write
ordering bugs because you changed fsync semantics is simply another
reason for not changing behaviour in the first place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
