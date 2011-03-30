Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1C3R4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab1C3R4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:56:50 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        hch@infradead.org
Subject: Re: block: eliminate ELEVATOR_INSERT_REQUEUE
References: <20110328221547.GA1118@redhat.com>
	<x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
	<20110329175458.GE24485@redhat.com>
	<20110330074123.GA17523@htj.dyndns.org>
	<20110330075752.GC17523@htj.dyndns.org> <4D92E2CD.6000909@kernel.dk>
	<20110330080203.GD17523@htj.dyndns.org>
	<20110330140123.GA28212@redhat.com>
	<20110330142751.GH17523@htj.dyndns.org>
	<20110330152248.GC1291@redhat.com>
	<20110330153024.GJ17523@htj.dyndns.org> <4D9364B0.5020604@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 30 Mar 2011 13:56:29 -0400
In-Reply-To: <4D9364B0.5020604@kernel.dk> (Jens Axboe's message of "Wed, 30
	Mar 2011 19:13:20 +0200")
Message-ID: <x49zkoclcfm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 2011-03-30 17:30, Tejun Heo wrote:
>> On Wed, Mar 30, 2011 at 11:22:48AM -0400, Vivek Goyal wrote:
>>> So wee need this as stable fix because FLUSH request can get ahead of
>>> REQUEUED requests and it can break some drivers?
>> 
>> Yes, I think so.  All we need is just replacing elv_insert() calls in
>> blk-flush.c with list_add_tail().  Something like the following.  I'll
>> test it and send a proper patch later.  Thanks.
>
> I'd suggest I just mark the queued patch for stable.

Could you document the nuance in that patch, please?

Thanks,
Jeff
