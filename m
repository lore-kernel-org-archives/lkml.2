Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1C3H57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:57:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43633 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1C3H56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A0VD0EkJ48Q9QgAupOMMz/liiODF5uSh0PsVTAHD4jeBkd867knpj9OuFE69R1AmL4
         48DkzGIvT+/0OUTdW0cBhjTjZQY02XoDifoAJ2BPX/vUA5Uh4XjbZ3KCWGbLFhWxxgz4
         MDKxYPMpHk6NkwIEfSscKGfRCdBBWTzM/fXmk=
Date: Wed, 30 Mar 2011 09:57:52 +0200
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE (was: Re:
 elevator private data for REQ_FLUSH)
Message-ID: <20110330075752.GC17523@htj.dyndns.org>
References: <20110325154024.GA16029@redhat.com>
 <4D8CB9C9.5010208@kernel.dk>
 <20110325185455.GA2969@redhat.com>
 <4D8CF202.9010809@kernel.dk>
 <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330074123.GA17523@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 09:41:23AM +0200, Tejun Heo wrote:
> IIRC, at least in the requeue path, some drivers depend on front
> queueing for forward progress guarantee.  Forward progress for
> prepping is guaranteed by mempool (or something like that) and when
> the request is retried, it should stay at the front of the queue;
> otherwise, prepping can stall with prepped requests stuck behind
> unprepped ones.

After writing the above, I think the current flush implementation
actually is violating the above.  I think the problem is over-use of
front insertion.  Flush can just append to the dispatch queue.  Front
insertion should only be used by requeueing, really.

Thanks.

-- 
tejun
