Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1HHTcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:32:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39668 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1HHTcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:32:33 -0400
Date: Mon, 8 Aug 2011 21:32:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 11/11] DIO: optimize cache misses in the submission path
Message-ID: <20110808193231.GM5782@one.firstfloor.org>
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org> <1312259893-4548-12-git-send-email-andi@firstfloor.org> <x49zkjjg2w5.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49zkjjg2w5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I bet we could default to using the smaller block size all the time, and
> still be able to detect when we don't have to do the sub-block zeroing.
> Maybe that would be a good follow-on patch.

It doesn't really matter because it's out of the fast path now.

> > +	/* 
> > +	 * Avoid references to bdev if not absolutely needed to give
> > +	 * the early prefetch in the caller enough time.
> > +	 */
> >  
> > -	if (offset & blocksize_mask) {
> > +	if (unlikely(offset & blocksize_mask)) {
> 
> You can't make this assumption.  Userspace controls what size/alignment
> of blocks to send in.

What assumption do you mean?

The code semantics are identical, just the place where I fetch
the block size is different (unless I missed something of course)


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
