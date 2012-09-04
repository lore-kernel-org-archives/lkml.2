Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab2IDS07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:26:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63036 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab2IDS05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:26:57 -0400
Date: Tue, 4 Sep 2012 11:26:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>,
        Kent Overstreet <koverstreet@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120904182633.GB3638@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120903004927.GM15292@dastard>
 <20120904135422.GC13768@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904135422.GC13768@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 04, 2012 at 09:54:23AM -0400, Vivek Goyal wrote:
> > Given that we are working around stack depth issues in the
> > filesystems already in several places, and now it seems like there's
> > a reason to work around it in the block layers as well, shouldn't we
> > simply increase the default stack size rather than introduce
> > complexity and performance regressions to try and work around not
> > having enough stack?
> 
> Dave,
> 
> In this particular instance, we really don't have any bug reports of
> stack overflowing. Just discussing what will happen if we make 
> generic_make_request() recursive again.

I think there was one and that's why we added the bio_list thing.

> > I mean, we can deal with it like the ia32 4k stack issue was dealt
> > with (i.e. ignore those stupid XFS people, that's an XFS bug), or
> > we can face the reality that storage stacks have become so complex
> > that 8k is no longer a big enough stack for a modern system....
> 
> So first question will be, what's the right stack size? If we make
> generic_make_request() recursive, then at some storage stack depth we will
> overflow stack anyway (if we have created too deep a stack). Hence
> keeping current logic kind of makes sense as in theory we can support
> arbitrary depth of storage stack.

But, yeah, this can't be solved by enlarging the stack size.  The
upper limit is unbound.

Thanks.

-- 
tejun
