Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1C3Rc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:32:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33611 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1C3Rc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SDB5kLEWH5Mc+fp6pVklNjHRJD0XfgXS5EsZz7hGph5n89VZbBhbuo62QKALWZde+y
         sbm6nt1RZL0+vxKsGO7S4i1vDmjvF8kaRozemvKHs9Yt3bY16rFyNitINnkSAF6LCGqH
         wwnLlXKDLbIvh0a3e9KUGDDy8JCRQJtUCIvm0=
Date: Wed, 30 Mar 2011 19:32:52 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        hch@infradead.org
Subject: Re: block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330173252.GA24058@htj.dyndns.org>
References: <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
 <20110330075752.GC17523@htj.dyndns.org>
 <4D92E2CD.6000909@kernel.dk>
 <20110330080203.GD17523@htj.dyndns.org>
 <20110330140123.GA28212@redhat.com>
 <20110330142751.GH17523@htj.dyndns.org>
 <20110330152248.GC1291@redhat.com>
 <20110330153024.GJ17523@htj.dyndns.org>
 <4D9364B0.5020604@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9364B0.5020604@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 07:13:20PM +0200, Jens Axboe wrote:
> On 2011-03-30 17:30, Tejun Heo wrote:
> > On Wed, Mar 30, 2011 at 11:22:48AM -0400, Vivek Goyal wrote:
> >> So wee need this as stable fix because FLUSH request can get ahead of
> >> REQUEUED requests and it can break some drivers?
> > 
> > Yes, I think so.  All we need is just replacing elv_insert() calls in
> > blk-flush.c with list_add_tail().  Something like the following.  I'll
> > test it and send a proper patch later.  Thanks.
> 
> I'd suggest I just mark the queued patch for stable.

Ah, right.  It might not apply without conflict but they're basically
the same changes.  Thanks.

-- 
tejun
