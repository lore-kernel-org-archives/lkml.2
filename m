Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1DANRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:17:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38371 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1DANRv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 1 Apr 2011 09:17:51 -0400
Date: Fri, 1 Apr 2011 09:17:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Merge window closed - 2.6.39-rc1 out
Message-ID: <20110401131713.GA16734@dumpdata.com>
References: <AANLkTikwbY5mm10ZWg7B6XeSBkZXFqKcYVZfJCi2QGx_@mail.gmail.com>
 <20110330120151.GA23358@infradead.org>
 <20110330144359.GA16430@dumpdata.com>
 <20110330222909.GA26174@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330222909.GA26174@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D95D05C.0122:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 06:29:09PM -0400, Christoph Hellwig wrote:
>  (1) it still has the totally stupid interface of a global dispatch table.
>      Either it does make sense to have different providers, in which
>      case you want the dispatch table on a per-superblock or whatever
>      granularity, or you really want just one and can have static calls
>      into it, and get rid of this whole layer
>  (2) it still requires totally pointless calls from local filesystem to
>      initialize a pool ID.  The filesystem really should not need to
>      care about any of this.

Thank you for taking a look at the patches. I think what you are saying
is that the opt-in interface (where only those fs that want it) are using,
is not proper. It should be in for everybody? Hmm.. let me ponder this.

>  (3) it's still lacking a good user submitted with it.  And with that
>      I don't mean junk code shoved into staging where it's bitrotting.

I think when one takes user cases and try to use one type of matrix (say,
how many customers are using it) but use another (how many enterprise
clients are clamoring for it) you get drastically different numbers.

If you just use one ruler to evaluate acceptance, then maybe
unicore32 (just one company), or ILO (small community compared to SCST)
should have not been merged b/c of that? But if you think of other
acceptance rules then it makes sense.

> 
> It also has an entirely new bug, in that it assumes every inode has
> a dentry on the alias list.  Did you only ever test this with filesystem
> that do not have export operations?  Otherwise the no-dentry case should
> be fairly trivial to trigger due the placement of the hooks.

Aha! Thank you for spotting that. Dan did post a patch for this:
https://lkml.org/lkml/2011/3/3/291

And he should have pulled it in his tree <sigh> Will ask him to create
a branch with this bug-fix.
> 
> And of course there's still no convincing use case for all of this.
