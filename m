Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab0KJXoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:44:46 -0500
Received: from bld-mail20.adl6.internode.on.net ([150.101.137.105]:41106 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757009Ab0KJXop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:44:45 -0500
Date: Thu, 11 Nov 2010 10:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, dave b <db.pub.mail@gmail.com>,
        Sanjoy Mahajan <sanjoy@olin.edu>, Jesper Juhl <jj@chaosbits.net>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101110234352.GA22876@dastard>
References: <20101105014334.GF13830@dastard>
 <E1PELiI-0001Pj-8g@approx.mit.edu>
 <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
 <4CD696B4.6070002@kernel.dk>
 <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
 <20101110013255.GR2715@dastard>
 <AANLkTinpLuzd5c+WqXoa_0Z=nv=mDgd-k4QZbBZHsQnD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinpLuzd5c+WqXoa_0Z=nv=mDgd-k4QZbBZHsQnD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 07:59:10AM -0800, Linus Torvalds wrote:
> On Tue, Nov 9, 2010 at 5:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Don't forget to mention data=writeback is not the default because if
> > your system crashes or you lose power running in this mode it will
> > *CORRUPT YOUR FILESYSTEM* and you *WILL LOSE DATA*.
> 
> You will lose data even with data=ordered. All the data that didn't
> get logged before the crash is lost anyway.
> 
> So your argument is kind of dishonest. The thing is, if you have a
> crash or power outage or whatever, the only data you can really rely
> on is always going to be the data that you fsync'ed before the crash.
> Everything else is just gravy.

I crash kernels tens of times every day doing filesystem testing.
With data=ordered I have not seen a corrupted root filesystem as a
result of normal testing and crashing as long as I can remember.
With data=writeback, I'll have corrupted root ext3 partitions in
under a day. Hardly what I'd call stable or something you'd want
to deploy in production.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
