Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab1IAQbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:31:12 -0400
Received: from fn.samba.org ([216.83.154.106]:38213 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756959Ab1IAQbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:31:11 -0400
Date: Thu, 1 Sep 2011 09:31:07 -0700
From: Jeremy Allison <jra@samba.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Allison <jra@samba.org>, Ulrich Drepper <drepper@akkadia.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110901163107.GE758@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20110830155438.bc31ab99.akpm@linux-foundation.org>
 <20110830230342.GB16326@samba2>
 <20110830161130.592df746.akpm@linux-foundation.org>
 <4E5E152A.9050804@akkadia.org>
 <20110831165954.GC1611@samba2>
 <4E5F690C.4010209@akkadia.org>
 <20110901155845.GA758@samba2>
 <20110901160436.GA13556@infradead.org>
 <20110901161531.GB758@samba2>
 <20110901162337.GA28802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901162337.GA28802@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 12:23:37PM -0400, Christoph Hellwig wrote:
> On Thu, Sep 01, 2011 at 09:15:31AM -0700, Jeremy Allison wrote:
> > > We could easily give you an fcntl / dup3 flag to only release posix
> > > locks on the final close of a struct file if that helps you.
> > 
> > That would help us enormously - it'd be Linux only of course but
> > we could easily add support for that.
> > 
> > Can you propose the design here so we can run it past some of the
> > Solaris/FreeBSD folks (it'd be nice if we could get broader adoption) ?
> 
> Not sure there is all that much to discuss.  The idea is to have locks
> that behave like Posix locks, but only get release when the last duped
> fd to them gets released.
> 
> We'd define a new O_LOCKS_WHATEVER flag for it, which gets set either
> using fcntl(..., F_SETFL, ...) or dup3.  All in all that should be less
> than 50 lines of code in the kernel.

Ok, so it'd be set at open() time, say:

O_CLOLOCK_PERSIST

(to match the naming of something like O_CLOEXEC) and be available to set
with F_SETFD via an fcntl and dup3 call ?

> The alternative would be to design a different lock type, but that would
> be a lot more invasive, and not provide any real benefits.

No, we don't want that thanks :-).

Jeremy
