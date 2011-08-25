Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1HYGkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 02:40:46 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57913 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474Ab1HYGko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 02:40:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQCADbtVU55LIxDgWdsb2JhbABDqAAVAQEWJiWBQAEBBTocIxAIAw4KLhQlAyETwj0Ohj0Em1aIUA
Date: Thu, 25 Aug 2011 16:40:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, dchinner@redhat.com
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Message-ID: <20110825064039.GO3162@dastard>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <1309275199-10801-5-git-send-email-josef@redhat.com>
 <20110825060632.GA9933@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825060632.GA9933@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 02:06:32AM -0400, Christoph Hellwig wrote:
> On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
> > This is a test to make sure seek_data/seek_hole is acting like it does on
> > Solaris.  It will check to see if the fs supports finding a hole or not and will
> > adjust as necessary.
> 
> Can you resend this with any updates that happened in the meantime?
> 
> Dave also still had some comments about semantics, so it might be worth
> to incorporate that as well.

The main questions I had when looking at this was how we should
handle unwritten extents - the only answer I got was along the lines
of "we'll deal with that once filesystems have implemented
something". That's a bit of a chicken-and-egg situation, and doesn't
help me decide what is the best thing to do. I don't want to have to
re-implement this code when it's decided i did the wrong thing
initially.

The most basic question I really want answered is this:

	- is preallocated space a HOLE, or is it DATA?

Whatever the answer, I think it should be consistently
presented by all filesystems that support preallocation, and it
should be encoded into the generic SEEK_HOLE/SEEK_DATA tests....

Answering that question then helps answer the more complex questions
I had, like:

	- what does SEEK_DATA return when you have a file layout
	  like "hole-prealloc-data"?

Answers to that sort of question need to be known so we can write
corner-case tests to correctly verify the filesystem implementation.

I like to do better than present userspace with an interface that
behaves vastly different depending on the underlying filesystem, but
if the answer is "definition and implementation is entirely
filesystem specific" then I'll just go make something up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
