Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1CVVAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:00:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33875 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1CVVAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:00:35 -0400
Date: Tue, 22 Mar 2011 17:00:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: merging discard request in the block layer
Message-ID: <20110322210034.GA9349@infradead.org>
References: <20110322194755.GA20122@infradead.org>
 <4D88FE5E.1010204@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D88FE5E.1010204@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 08:54:06PM +0100, Jens Axboe wrote:
> > Index: xfs/block/blk-merge.c
> > ===================================================================
> > --- xfs.orig/block/blk-merge.c	2011-03-22 13:07:24.733857580 +0100
> > +++ xfs/block/blk-merge.c	2011-03-22 13:08:17.448856577 +0100
> > @@ -373,7 +373,7 @@ static int attempt_merge(struct request_
> >  	/*
> >  	 * Don't merge file system requests and discard requests
> >  	 */
> > -	if ((req->cmd_flags & REQ_DISCARD) != (next->cmd_flags & REQ_DISCARD))
> > +	if ((req->cmd_flags & REQ_DISCARD) || (next->cmd_flags & REQ_DISCARD))
> >  		return 0;
> >  
> >  	/*
> 
> That's not going to be enough, you want to disable the bio to request
> merging of discards as well in elevator.c:elv_rq_merge_ok(). Does
> that then fix it?

Applying the same fix in elv_rq_merge_ok seems to fix the issue, at
least the xfstests testcase that usually hits it is completes ok.

