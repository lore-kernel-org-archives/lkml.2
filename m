Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab1DOVN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:13:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab1DOVN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:13:58 -0400
Date: Fri, 15 Apr 2011 17:13:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: hugetlb locking bug.
Message-ID: <20110415211334.GA24870@infradead.org>
References: <20110415201652.GA5131@redhat.com>
 <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
 <20110415205712.GA13049@infradead.org>
 <1302901766.2035.39.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302901766.2035.39.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 11:09:26PM +0200, Peter Zijlstra wrote:
> Is there a sane reason they do their own magic, and thus need a copy of
> the logic, instead of using the generic code that already has it?

There is not need to use the inode hash for purely in-memory
filesystem.  The dcache tells us if an entry already exists,
so there is no need to a lru list, hash or other overhead.

