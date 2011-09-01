Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab1IAQes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:34:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41445
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756959Ab1IAQeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:34:46 -0400
Date: Thu, 1 Sep 2011 12:34:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeremy Allison <jra@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ulrich Drepper <drepper@akkadia.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110901163435.GA7641@infradead.org>
References: <20110830230342.GB16326@samba2>
 <20110830161130.592df746.akpm@linux-foundation.org>
 <4E5E152A.9050804@akkadia.org>
 <20110831165954.GC1611@samba2>
 <4E5F690C.4010209@akkadia.org>
 <20110901155845.GA758@samba2>
 <20110901160436.GA13556@infradead.org>
 <20110901161531.GB758@samba2>
 <20110901162337.GA28802@infradead.org>
 <20110901163107.GE758@samba2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901163107.GE758@samba2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 09:31:07AM -0700, Jeremy Allison wrote:
> > We'd define a new O_LOCKS_WHATEVER flag for it, which gets set either
> > using fcntl(..., F_SETFL, ...) or dup3.  All in all that should be less
> > than 50 lines of code in the kernel.
> 
> Ok, so it'd be set at open() time, say:
> 
> O_CLOLOCK_PERSIST
> 
> (to match the naming of something like O_CLOEXEC) and be available to set
> with F_SETFD via an fcntl and dup3 call ?

Yes, that's the idea.

