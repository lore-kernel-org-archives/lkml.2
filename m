Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1C3LUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:20:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58223 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab1C3LUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bauOKwddRrjWh6ZlsLBYdWzXrWr8zzrG9haRx2PwC0yXjlVqOjf2ZAmqvgd4QIWSJb
         UE5ZJSTggRi/uT+rnggVnymFlK8bfZll9DgTE5oeU/vMft9H3O2B4HEfEN/9BvIP0yyI
         IzRMJs71R+H2feRvsN0hq1S+JEB1km/MDHXz0=
Date: Wed, 30 Mar 2011 13:20:40 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330112040.GF17523@htj.dyndns.org>
References: <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
 <20110330075752.GC17523@htj.dyndns.org>
 <4D92E2CD.6000909@kernel.dk>
 <20110330080203.GD17523@htj.dyndns.org>
 <4D9302ED.4030807@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9302ED.4030807@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Wed, Mar 30, 2011 at 12:16:13PM +0200, Jens Axboe wrote:
> @@ -261,7 +261,7 @@ static bool blk_kick_flush(struct request_queue *q)
>  	q->flush_rq.end_io = flush_end_io;
>  
>  	q->flush_pending_idx ^= 1;
> -	elv_insert(q, &q->flush_rq, ELEVATOR_INSERT_REQUEUE);
> +	__elv_add_request(q, &q->flush_rq, ELEVATOR_INSERT_FLUSH);

Shouldn't this be list_add_tail(&rq->queuelist, &q->queue_head)?
__elv_add_request(FLUSH) calls back into blk_insert_flush() which
decomposes the flush request from FS into flush sequence.
blk_kick_flush() is used to insert the decomposed sequence requests
into the dispatch queue.

Thanks.

-- 
tejun
