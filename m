Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab0KODtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:49:53 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:60089 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757399Ab0KODtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:49:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALc84Ex5LdSF/2dsb2JhbACiTnK7HIVKBA
Date: Mon, 15 Nov 2010 14:49:46 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patches] seqlock: add barrier-less special cases for seqcounts
Message-ID: <20101115034946.GA3320@amd>
References: <20101111080012.GB10210@amd>
 <AANLkTinAY=jbtEEFa0XgYiHs8Lj21Q58FhPpU+TOtWnf@mail.gmail.com>
 <20101112230650.GA3317@amd>
 <AANLkTi=3xTcqasoN77o3Hk9kyfT4+MbFR7K7CZE=U36Y@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=3xTcqasoN77o3Hk9kyfT4+MbFR7K7CZE=U36Y@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 03:52:55PM -0800, Linus Torvalds wrote:
> On Fri, Nov 12, 2010 at 3:06 PM, Nick Piggin <npiggin@kernel.dk> wrote:
> . ...
> > seq2 = read_seqlock_begin(&child->d_seq);
> > if (read_seqcount_retry(&dentry->d_seq, seq))
> >  /* bail out */
> 
> So the only issue is that this particular back-to-back sequence with
> these kinds of "take one seqlock and release the previous one" where
> you currently end up having basically one smp_rmb() at the end of
> "read_seqlock_begin()", only to be followed immediately by another one
> starting out the "read_seqcount_retry()"?

I think basically yes, I'll have to take another look at the code.


> If so, I think we should make _that_ operation ("move from one seqlock
> to another") be the special one, because it smells like in general,
> using the special non-locking versions is going to be a very subtle
> interface.

OK, that sounds like a good idea. I'll see if that's applicable.

