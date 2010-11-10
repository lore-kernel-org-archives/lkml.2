Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab0KJPDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:03:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41902 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab0KJPDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:03:36 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, dave b <db.pub.mail@gmail.com>,
        Sanjoy Mahajan <sanjoy@olin.edu>, Jesper Juhl <jj@chaosbits.net>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
In-reply-to: <20101110145712.GB22073@infradead.org>
References: <20101105014334.GF13830@dastard> <E1PELiI-0001Pj-8g@approx.mit.edu> <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com> <4CD696B4.6070002@kernel.dk> <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com> <20101110013255.GR2715@dastard> <C70A546B-6BC5-49CA-9E34-E69F494A71A0@mit.edu> <20101110145712.GB22073@infradead.org>
Date: Wed, 10 Nov 2010 10:00:36 -0500
Message-Id: <1289401148-sup-3632@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Christoph Hellwig's message of 2010-11-10 09:57:12 -0500:
> On Wed, Nov 10, 2010 at 09:33:29AM -0500, Theodore Tso wrote:
> > The chance that this occurs using data=writeback in ext4 is much less, BTW, because with delayed allocation we delay updating the inode until right before we write the block.  I have a plan for changing things so that we write the data blocks *first* and then update the metadata blocks second, which will mean that ext4 data=ordered will go away entirely, and we'll get both the safety and as well as avoiding the forced data page writeouts during journal commits.
> 
> That's the scheme used by XFS and btrfs in one form or another.  Chris
> also had a patch to implement it for ext3, which unfortunately fell
> under the floor.

It probably still applies, but by the time I had it stable I realized
that ext4 was really a better place to fix this stuff.  ext3 is what it
is (good and bad), and a big change like my data=guarded code probably
isn't the best way to help.

-chris
