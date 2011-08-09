Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1HIRzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:55:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60738 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1HIRzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:55:38 -0400
Date: Tue, 9 Aug 2011 19:55:09 +0200
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        dm-devel@redhat.com
Subject: Re: block: properly handle flush/fua requests in
 blk_insert_cloned_request
Message-ID: <20110809175509.GF23842@htj.dyndns.org>
References: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
 <20110809153826.GB23842@htj.dyndns.org>
 <x49liv2eg34.fsf@segfault.boston.devel.redhat.com>
 <20110809161334.GC23842@htj.dyndns.org>
 <20110809174347.GA13293@redhat.com>
 <20110809175237.GA978@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809175237.GA978@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 01:52:37PM -0400, Vivek Goyal wrote:
> > +	/*
> > +	 * All FLUSH/FUA requests are expected to have gone through the
> > +	 * flush machinary.  If a request's cmd_flags doesn't match the
> > +	 * flush_flags of the underlying request_queue it is a bug.
> > +	 */
> > +	BUG_ON((rq->cmd_flags & REQ_FLUSH) && !(q->flush_flags & REQ_FLUSH));
> > +	BUG_ON((rq->cmd_flags & REQ_FUA) && !(q->flush_flags & REQ_FUA));
> > +
> 
> Actually this makes sense and is simple. :-) Is BUG_ON() too harsh, how
> about WARN_ONCE() variants? To me system continues to work so warning 
> is probably good enough.

I don't really think this is the right thing to do.  It makes the
cloning a special case.  It looks easy now but puts it in its own
special box which usually ends up ugly in the long run.  Let's get the
thing fixed and let it play like others do.  There's nothing
fundamentally broken with the usual mechanism.

Thanks.

-- 
tejun
