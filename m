Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1IAQ5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:57:22 -0400
Received: from fn.samba.org ([216.83.154.106]:50182 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab1IAQ5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:57:21 -0400
Date: Thu, 1 Sep 2011 09:57:18 -0700
From: Jeremy Allison <jra@samba.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Allison <jra@samba.org>, Ulrich Drepper <drepper@akkadia.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110901165718.GG758@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <4E5E152A.9050804@akkadia.org>
 <20110831165954.GC1611@samba2>
 <4E5F690C.4010209@akkadia.org>
 <20110901155845.GA758@samba2>
 <20110901160436.GA13556@infradead.org>
 <20110901161531.GB758@samba2>
 <20110901162337.GA28802@infradead.org>
 <20110901163107.GE758@samba2>
 <20110901163452.GF758@samba2>
 <20110901164554.GB7641@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901164554.GB7641@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 12:45:54PM -0400, Christoph Hellwig wrote:
> On Thu, Sep 01, 2011 at 09:34:52AM -0700, Jeremy Allison wrote:
> > > 
> > > (to match the naming of something like O_CLOEXEC) and be available to set
> > > with F_SETFD via an fcntl and dup3 call ?
> > 
> > Ah, looking at fcntl - do you want to set/get this via F_SETFD/F_GETFD,
> > or via F_SETFL/F_GETFL ? i.e. is this a file descritor flag, or a status
> > flag ? I'd guess a file descriptor flag but I'm not sure of the difference
> > here..
> 
> F_SETFD/F_GETFD operates on an entry in the fd table, e.g. separately
> if you have duped fds.  That's exactly what we do _not_ want here.

Ah, ok - I understand the difference now. So it's a status flag
get/set with F_SETFL/F_GETFL.

Ok, that works for me. Get me a patch in the kernel and I'll code
up the Samba changes very shortly (actually should be quite
easy :-).

Jeremy.
