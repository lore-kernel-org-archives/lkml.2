Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1C3RNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:13:25 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46768 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab1C3RNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:13:24 -0400
Message-ID: <4D9364B0.5020604@kernel.dk>
Date: Wed, 30 Mar 2011 19:13:20 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        hch@infradead.org
Subject: Re: block: eliminate ELEVATOR_INSERT_REQUEUE
References: <20110328221547.GA1118@redhat.com> <x49y63yvwum.fsf@segfault.boston.devel.redhat.com> <20110329175458.GE24485@redhat.com> <20110330074123.GA17523@htj.dyndns.org> <20110330075752.GC17523@htj.dyndns.org> <4D92E2CD.6000909@kernel.dk> <20110330080203.GD17523@htj.dyndns.org> <20110330140123.GA28212@redhat.com> <20110330142751.GH17523@htj.dyndns.org> <20110330152248.GC1291@redhat.com> <20110330153024.GJ17523@htj.dyndns.org>
In-Reply-To: <20110330153024.GJ17523@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-30 17:30, Tejun Heo wrote:
> On Wed, Mar 30, 2011 at 11:22:48AM -0400, Vivek Goyal wrote:
>> So wee need this as stable fix because FLUSH request can get ahead of
>> REQUEUED requests and it can break some drivers?
> 
> Yes, I think so.  All we need is just replacing elv_insert() calls in
> blk-flush.c with list_add_tail().  Something like the following.  I'll
> test it and send a proper patch later.  Thanks.

I'd suggest I just mark the queued patch for stable.

-- 
Jens Axboe

