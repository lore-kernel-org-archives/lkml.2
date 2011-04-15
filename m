Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab1DOVHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:07:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab1DOVHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:07:01 -0400
Subject: Re: hugetlb locking bug.
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20110415205712.GA13049@infradead.org>
References: <20110415201652.GA5131@redhat.com>
	 <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
	 <20110415205712.GA13049@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 23:09:26 +0200
Message-ID: <1302901766.2035.39.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 16:57 -0400, Christoph Hellwig wrote:
> On Fri, Apr 15, 2011 at 01:49:04PM -0700, Linus Torvalds wrote:
> > And I really thought we annotated it as such with different
> > "lockdep_set_class()" cases (ie the whole
> > 
> >   lockdep_set_class(&inode->i_mutex,&type->i_mutex_dir_key);
> > 
> > for the S_ISDIR case in unlock_new_inode().
> > 
> > Can somebody more alert than me see why this lockdep issue still
> > triggers with hugetlbfs?
> 
> Because it doesn't use iget or unlock_new_inode, but rather calls
> directly into new_inode().  It and other filesystems not using
> unlock_new_inode will need a local copy of that logic.

Is there a sane reason they do their own magic, and thus need a copy of
the logic, instead of using the generic code that already has it?

