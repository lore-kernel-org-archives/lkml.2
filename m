Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab1IAQPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:15:34 -0400
Received: from fn.samba.org ([216.83.154.106]:52271 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570Ab1IAQPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:15:33 -0400
Date: Thu, 1 Sep 2011 09:15:31 -0700
From: Jeremy Allison <jra@samba.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Allison <jra@samba.org>, Ulrich Drepper <drepper@akkadia.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110901161531.GB758@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20110830154157.d802d097.akpm@linux-foundation.org>
 <CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com>
 <20110830155438.bc31ab99.akpm@linux-foundation.org>
 <20110830230342.GB16326@samba2>
 <20110830161130.592df746.akpm@linux-foundation.org>
 <4E5E152A.9050804@akkadia.org>
 <20110831165954.GC1611@samba2>
 <4E5F690C.4010209@akkadia.org>
 <20110901155845.GA758@samba2>
 <20110901160436.GA13556@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901160436.GA13556@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 12:04:36PM -0400, Christoph Hellwig wrote:
> On Thu, Sep 01, 2011 at 08:58:45AM -0700, Jeremy Allison wrote:
> > Yes I did consider that of course. Problem is that leads you to the
> > nightmare that is losing all fcntl locks on the file when any of the
> > descriptors are closed. Of course we already have internal work arounds
> > for that - but they're not scalable in this case.  We'd have to dup on
> > every read/write, and because of the fcntl lock problem we have to keep
> > all fd's around until the final close of the file. Don't tell us to
> > implement our own locking instead because (a) we already do in the case
> > where we don't need locking consistency with NFS and (b) most vendors insist on
> > locking consistency with NFS - not good if locks on one protocol aren't
> > seen by another.
> 
> We could easily give you an fcntl / dup3 flag to only release posix
> locks on the final close of a struct file if that helps you.

That would help us enormously - it'd be Linux only of course but
we could easily add support for that.

Can you propose the design here so we can run it past some of the
Solaris/FreeBSD folks (it'd be nice if we could get broader adoption) ?

Jeremy.
