Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0KJXiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:38:23 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:51725 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757417Ab0KJXiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:38:22 -0500
Date: Thu, 11 Nov 2010 10:36:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, dave b <db.pub.mail@gmail.com>,
        Sanjoy Mahajan <sanjoy@olin.edu>, Jesper Juhl <jj@chaosbits.net>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101110233648.GY2715@dastard>
References: <20101105014334.GF13830@dastard>
 <E1PELiI-0001Pj-8g@approx.mit.edu>
 <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
 <4CD696B4.6070002@kernel.dk>
 <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
 <20101110013255.GR2715@dastard>
 <C70A546B-6BC5-49CA-9E34-E69F494A71A0@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C70A546B-6BC5-49CA-9E34-E69F494A71A0@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 09:33:29AM -0500, Theodore Tso wrote:
> 
> On Nov 9, 2010, at 8:32 PM, Dave Chinner wrote:
> 
> > Don't forget to mention data=writeback is not the default because if
> > your system crashes or you lose power running in this mode it will
> > *CORRUPT YOUR FILESYSTEM* and you *WILL LOSE DATA*. Not to mention
> > the significant security issues (e.g stale data exposure) that also
> > occur even if the filesystem is not corrupted by the crash. IOWs,
> > data=writeback is the "fast but I'll eat your data" option for ext3.
> 
> This is strictly speaking not true.  Using data=writeback will not
> cause you to lose any data --- at least, not any more than you
> would without the feature.   If you have applications that write
> files in an unsafe way, that data is going to be lost, one way or
> another.  (i.e., with XFS in a similar situation you'll get a
> zero-length file)   The difference is that in the case of a system
> crash, there may be unwritten data revealed if you use
> data=writeback.  This could be a security exposure, especially if
> you are using your system in as time-sharing system, and where you
> see the contents of deleted files belonging to another user.

In theory, that's all that is _supposed_ to happen. However, my
recent experience is that massive ext3 filesystem corruption occurs
in data=writeback mode when the system crashes and that does not
happen in ordered mode.

Why do you think i posted the patches to change the default back to
ordered mode a few months back? I basically trashed the root ext3
partitions on three test machines (to the point where >5000 files
across /sbin, /bin, /lib and /usr were corrupted or missing and I
had to reinstall from scratch) when I'd forgotten to set the
ordered-is-defult config option in the kernel i was testing.  And
that is when the only thing being written to the root filesystems
was log files...

The worst part about this was that I also had ext3 filesystems
corrupted by crashes in such a way that e2fsck didn't detect it but
they would repeatedly trigger kernel crashes at runtime....

> So it is not an "eat your data" situation,

My experience says otherwise....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
