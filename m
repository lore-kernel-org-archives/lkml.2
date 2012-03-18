Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2CRWHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 18:07:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49236 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2CRWHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 18:07:52 -0400
Date: Sun, 18 Mar 2012 22:07:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [rfc][patches] fix for munmap/truncate races
Message-ID: <20120318220751.GD6589@ZenIV.linux.org.uk>
References: <20120318190744.GA6589@ZenIV.linux.org.uk>
 <CA+55aFwBEoD167oD=X9d6jR+wn6Tb-QFgZR+wGwdej4qakCMgg@mail.gmail.com>
 <20120318220610.GC6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120318220610.GC6589@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 10:06:10PM +0000, Al Viro wrote:
> On Sun, Mar 18, 2012 at 03:01:08PM -0700, Linus Torvalds wrote:
> > On Sun, Mar 18, 2012 at 12:07 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > - ? ? ? tlb_finish_mmu(&tlb, 0, end);
> > > + ? ? ? tlb_finish_mmu(&tlb, 0, -1);
> > 
> > Hmm. The fact that you drop the end pointer means that some
> > architectures that optimize the TLB flushing for ranges now
> > effectively can't do it any more.
> > 
> > Now, I think it's only ia64 that really is affected, but it *might* matter.
> > 
> > In particular, ia64 has some logic for "if you only flush one single
> > region, you can optimize it", and the region sizes are in the
> > terabytes. And I'm pretty sure you broke that - I'm just not entirely
> > sure how much we care.
> 
> Nope - ia64 check explicitly for precisely that case:
[snip]
... and everything else doesn't look at start or end at all.
