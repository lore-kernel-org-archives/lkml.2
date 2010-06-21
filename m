Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab0FUSwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:52:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0FUSws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:52:48 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 21 Jun 2010 14:52:41 -0400
In-Reply-To: <4C1F3916.4070608@kernel.dk> (Jens Axboe's message of "Mon, 21
	Jun 2010 12:04:06 +0200")
Message-ID: <x49mxuo6ww6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 2010-06-21 11:48, Christoph Hellwig wrote:
>> Now how do we use these flags in the block layer?
>>  
>>  - REQ_META
>> 
>> 	The only place where we ever use this flag is inside the
>> 	cfq scheduler. In cfq_choose_req we use it to give a meta
>> 	request priority over one that doesn't have it.  But before
>> 	that we already do the same preference check with rw_is_sync,
>> 	which evaluates to true for requests with that are either
>> 	reads or have REQ_SYNC set.  So for reads the REQ_META flag
>> 	here effectively is a no-op, and for writes it gives less
>> 	priority than REQ_SYNC.
>> 	In addition to that we use it to account for pending metadata
>> 	requests in cfq_rq_enqueued/cfq_remove_request which gets
>> 	checked in cfq_should_preempt to give priority to a meta
>> 	request if the other queue doesn't have any pending meta
>> 	requests.  But again this priority comes after a similar
>> 	check for sync requests that checks if the other queue has
>> 	been marked to have sync requests pending.
>
> It's also annotation for blktrace, so you can tell which parts of the IO
> is meta data etc. The scheduler impact is questionable, I doubt it makes
> a whole lot of difference.

Really?  Even after I showed the performance impact of setting that bit
for journal I/O?

http://lkml.org/lkml/2010/4/1/344

Cheers,
Jeff
