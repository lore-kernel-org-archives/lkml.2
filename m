Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab1JSQcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:32:07 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57226 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1JSQcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:32:05 -0400
Date: Wed, 19 Oct 2011 09:31:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCH 04/10] block: pass around REQ_* flags instead of broken
 down booleans during request alloc/free
Message-ID: <20111019163158.GB25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-5-git-send-email-tj@kernel.org>
 <20111019134424.GC1140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019134424.GC1140@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 19, 2011 at 09:44:24AM -0400, Vivek Goyal wrote:
> >  static struct request *
> > -blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
> > +blk_alloc_request(struct request_queue *q, unsigned int flags, gfp_t gfp_mask)
> >  {
> >  	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
> >  
> > @@ -586,12 +586,10 @@ blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
> >  
> >  	rq->cmd_flags = flags | REQ_ALLOCED;
> >  
> > -	if (priv) {
> > -		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
> > -			mempool_free(rq, q->rq.rq_pool);
> > -			return NULL;
> > -		}
> > -		rq->cmd_flags |= REQ_ELVPRIV;
> 
> Don't we need to set REQ_ELVPRIV in rq->cmd_flags in this new code?

The caller is now supposed to set REQ_ELVPRIV in @flags if it wants
elevator initialized, so the above "rq->cmd_flags = flags | REQ_ALLOCED"
should be enough.

Thanks.

-- 
tejun
