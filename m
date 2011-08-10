Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1HJPuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:50:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1HJPuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:50:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        dm-devel@redhat.com
Subject: Re: block: properly handle flush/fua requests in blk_insert_cloned_request
References: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
	<20110809153826.GB23842@htj.dyndns.org>
	<x49liv2eg34.fsf@segfault.boston.devel.redhat.com>
	<20110809161334.GC23842@htj.dyndns.org>
	<20110809174347.GA13293@redhat.com> <20110809175237.GA978@redhat.com>
	<20110809185531.GC13293@redhat.com>
	<20110809190509.GA31927@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 10 Aug 2011 11:49:56 -0400
In-Reply-To: <20110809190509.GA31927@redhat.com> (Vivek Goyal's message of
	"Tue, 9 Aug 2011 15:05:09 -0400")
Message-ID: <x49pqkdqna3.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Aug 09, 2011 at 02:55:31PM -0400, Mike Snitzer wrote:
>
> [..]
>> > > +	/*
>> > > +	 * All FLUSH/FUA requests are expected to have gone through the
>> > > +	 * flush machinary.  If a request's cmd_flags doesn't match the
>> > > +	 * flush_flags of the underlying request_queue it is a bug.
>> > > +	 */
>> > > +	BUG_ON((rq->cmd_flags & REQ_FLUSH) && !(q->flush_flags & REQ_FLUSH));
>> > > +	BUG_ON((rq->cmd_flags & REQ_FUA) && !(q->flush_flags & REQ_FUA));
>> > > +
>> > 
>> > Actually this makes sense and is simple. :-) Is BUG_ON() too harsh, how
>> > about WARN_ONCE() variants? To me system continues to work so warning 
>> > is probably good enough.
>> 
>> Sure, WARN_ONCE() is fine by me.
>> 
>> Seems Tejun wants a more involved fix though.
>
> Fixing it properly doesn't hurt. Makes it more future proof. In fact I am
> thinking what happens to blk_execute_rq() variants where one can prepare a
> request and send it down. What if caller sets FLUSH/FUA flags there.

Callers of blk_execute_rq are special.  Those aren't REQ_TYPE_FS
requests, and so the callers are responsible for doing their own
sequencing.

Cheers,
Jeff
