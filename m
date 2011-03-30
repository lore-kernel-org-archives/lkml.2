Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1C3H7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:59:11 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60220 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab1C3H7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:59:09 -0400
Message-ID: <4D92E2CD.6000909@kernel.dk>
Date: Wed, 30 Mar 2011 09:59:09 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
References: <20110325154024.GA16029@redhat.com> <4D8CB9C9.5010208@kernel.dk> <20110325185455.GA2969@redhat.com> <4D8CF202.9010809@kernel.dk> <20110326042156.GB28458@redhat.com> <20110328082321.GC16530@htj.dyndns.org> <20110328221547.GA1118@redhat.com> <x49y63yvwum.fsf@segfault.boston.devel.redhat.com> <20110329175458.GE24485@redhat.com> <20110330074123.GA17523@htj.dyndns.org> <20110330075752.GC17523@htj.dyndns.org>
In-Reply-To: <20110330075752.GC17523@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-30 09:57, Tejun Heo wrote:
> On Wed, Mar 30, 2011 at 09:41:23AM +0200, Tejun Heo wrote:
>> IIRC, at least in the requeue path, some drivers depend on front
>> queueing for forward progress guarantee.  Forward progress for
>> prepping is guaranteed by mempool (or something like that) and when
>> the request is retried, it should stay at the front of the queue;
>> otherwise, prepping can stall with prepped requests stuck behind
>> unprepped ones.
> 
> After writing the above, I think the current flush implementation
> actually is violating the above.  I think the problem is over-use of
> front insertion.  Flush can just append to the dispatch queue.  Front
> insertion should only be used by requeueing, really.

Pure front insert should be used for requeue and internal commands (like
spin up this drive, or get error information). Flush should append to
the dispatch list.

-- 
Jens Axboe

