Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab1DOV0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:26:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43474 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab1DOV0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:26:24 -0400
Date: Fri, 15 Apr 2011 17:26:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: hugetlb locking bug.
Message-ID: <20110415212600.GA3626@infradead.org>
References: <20110415201652.GA5131@redhat.com>
 <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
 <20110415205712.GA13049@infradead.org>
 <1302901766.2035.39.camel@laptop>
 <BANLkTimg+sVCAE17jLE9oz301oruVZbdbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimg+sVCAE17jLE9oz301oruVZbdbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 02:19:01PM -0700, Linus Torvalds wrote:
> On Fri, Apr 15, 2011 at 2:09 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2011-04-15 at 16:57 -0400, Christoph Hellwig wrote:
> >>
> >> Because it doesn't use iget or unlock_new_inode, but rather calls
> >> directly into new_inode(). ?It and other filesystems not using
> >> unlock_new_inode will need a local copy of that logic.
> >
> > Is there a sane reason they do their own magic, and thus need a copy of
> > the logic, instead of using the generic code that already has it?
> 
> Hmm. That all seems to be just an oversight.
> 
> Does this trivial one-liner work?
> 
> (Warning: whitespace damage and TOTALLY UNTESTED)

It'll get rid of the lockdep spat in favour of a WARN_ON, given that
inodes from new_inode() never have I_NEW set.

