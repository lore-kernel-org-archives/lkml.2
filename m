Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab1DOVUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:20:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab1DOVUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:20:42 -0400
Subject: Re: hugetlb locking bug.
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20110415211334.GA24870@infradead.org>
References: <20110415201652.GA5131@redhat.com>
	 <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
	 <20110415205712.GA13049@infradead.org> <1302901766.2035.39.camel@laptop>
	 <20110415211334.GA24870@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 23:23:03 +0200
Message-ID: <1302902583.2035.40.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 17:13 -0400, Christoph Hellwig wrote:
> On Fri, Apr 15, 2011 at 11:09:26PM +0200, Peter Zijlstra wrote:
> > Is there a sane reason they do their own magic, and thus need a copy of
> > the logic, instead of using the generic code that already has it?
> 
> There is not need to use the inode hash for purely in-memory
> filesystem.  The dcache tells us if an entry already exists,
> so there is no need to a lru list, hash or other overhead.

OK makes sense, should we then make some common code to share between
these in-memory filesystems so as to limit the number of copies of this
logic?

