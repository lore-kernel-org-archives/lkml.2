Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab2ICBS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 21:18:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34796 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab2ICBS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 21:18:26 -0400
Date: Sun, 2 Sep 2012 18:17:52 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120903011752.GC20060@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120903004927.GM15292@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903004927.GM15292@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 10:49:27AM +1000, Dave Chinner wrote:
> Given that we are working around stack depth issues in the
> filesystems already in several places, and now it seems like there's
> a reason to work around it in the block layers as well, shouldn't we
> simply increase the default stack size rather than introduce
> complexity and performance regressions to try and work around not
> having enough stack?
> 
> I mean, we can deal with it like the ia32 4k stack issue was dealt
> with (i.e. ignore those stupid XFS people, that's an XFS bug), or
> we can face the reality that storage stacks have become so complex
> that 8k is no longer a big enough stack for a modern system....

I'm not arguing against increasing the default stack size (I really
don't have an opinion there) - but it's not a solution for the block
layer, as stacking block devices can require an unbounded amount of
stack without the generic_make_request() convert recursion-to-iteration
thing.
