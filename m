Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0JHIST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:18:19 -0400
Received: from canuck.infradead.org ([134.117.69.58]:32879 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab0JHISR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:18:17 -0400
Date: Fri, 8 Oct 2010 04:18:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] fs: split locking of inode writeback and LRU lists
Message-ID: <20101008081816.GA17577@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-14-git-send-email-david@fromorbit.com>
 <20101008074243.GB24089@infradead.org>
 <20101008080018.GV4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008080018.GV4681@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 07:00:18PM +1100, Dave Chinner wrote:
> > >  
> > > -		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
> > > +		if (inode->i_state & (I_NEW | I_WILL_FREE | I_FREEING)) {
> > >  			requeue_io(inode);
> > >  			continue;
> > >  		}
> > 
> > What does this have to do with the rest of the patch?
> 
> That's because there's now a window between setting I_FREEING and taking
> the inode off the writeback list which means that we can see inodes
> in that state here. Generally it means that the code setting
> I_FREEING is spinning waiting for the wb->b_lock that this thread
> currently holds so it can be removed from the list.. Hence the requeue
> to move the inode out of the way and keep processing inodes for
> writeback.

That needs some documentation both in the changelog and in the code
I think.

