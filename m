Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0JPQUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:20:23 -0400
Received: from canuck.infradead.org ([134.117.69.58]:59891 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0JPQUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:20:22 -0400
Date: Sat, 16 Oct 2010 12:20:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] fs: split locking of inode writeback and LRU lists
Message-ID: <20101016162021.GE16861@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-14-git-send-email-david@fromorbit.com>
 <20101008074243.GB24089@infradead.org>
 <20101008080018.GV4681@dastard>
 <20101008081816.GA17577@infradead.org>
 <20101016075713.GQ19147@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016075713.GQ19147@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 06:57:13PM +1100, Nick Piggin wrote:
> > That needs some documentation both in the changelog and in the code
> > I think.
> 
> This is another instance where the irregular i_lock locking is making
> these little subtleties to the locking. I think that is actually much
> worse for maintainence/complexity than a few trylocks which can be
> mostly removed with rcu anyway (which are obvious because of the well
> documented lock order).

Care to explain why?  The I_FREEING and co checks are how we do things
all over the icache for a long time.  They are perfectly easy to
understand concept.  What I asked Dave about is documenting why he
changed things here.

