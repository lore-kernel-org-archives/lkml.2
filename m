Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0KJTJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:09:42 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34402 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755525Ab0KJTJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:09:40 -0500
Date: Wed, 10 Nov 2010 20:09:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, dave b <db.pub.mail@gmail.com>,
        Sanjoy Mahajan <sanjoy@olin.edu>, Jesper Juhl <jj@chaosbits.net>,
        Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101110190933.GA1497@ucw.cz>
References: <20101105014334.GF13830@dastard>
 <E1PELiI-0001Pj-8g@approx.mit.edu>
 <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
 <4CD696B4.6070002@kernel.dk>
 <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
 <20101110013255.GR2715@dastard>
 <20101110142037.GA1447@ucw.cz>
 <20101110142721.GA14496@elte.hu>
 <20101110145511.GA22073@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110145511.GA22073@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > That is data that was freshly touched around the time the system went down, right?
> > 
> > I.e. data that was probably half-modified by user-space to begin with.
> 
> It's data that wasn't synced out yet, yes.  Which isn't the problem per
> se.  With ext3/4 in ordered mode, or xfs, or btrfs the file size won't
> be incremented until the data is written.  in ext3/4 in writeback mode
> (or various non-journaling filesystems) however the inode size is
> updated, and metadagta changes are logged.  Besides exposing stale
> data which is a security risk in multi-user systems it also means the
> inode looks modified (by size and timestamps), but contains other data
> than actually written.

Well, afaict thats traditional unix behaviour... while it is not user
friendly, I'd not call it 'corrupted filesytem'.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
