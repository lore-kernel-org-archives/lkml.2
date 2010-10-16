Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0JPQTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:19:17 -0400
Received: from canuck.infradead.org ([134.117.69.58]:32936 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab0JPQTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:19:15 -0400
Date: Sat, 16 Oct 2010 12:19:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] fs: Protect inode->i_state with th einode->i_lock
Message-ID: <20101016161914.GD16861@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-15-git-send-email-david@fromorbit.com>
 <20101008074932.GC24089@infradead.org>
 <20101008080428.GW4681@dastard>
 <20101008081843.GB17577@infradead.org>
 <20101016075709.GP19147@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016075709.GP19147@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 06:57:09PM +1100, Nick Piggin wrote:
> > > Ah, done thinking now! I was so the i_state field had been set
> > > before the inode was added to various lists and potentially
> > > accessable to other threads. I should probably add a comment to that
> > > effect, right?
> > 
> > Yes, please.
> 
> This is due to i_lock not covering all the icache state of the inode,
> so you have to make these synchronisation changes like this.
> 
> I much prefer such proposals to go at the end of my series, where I
> will probably nack them (and use rcu instead if the remaining trylocks
> are such a big issue).

To get back to the context - what it changes is setting up i_state =
I_NEW before adding the inode to the sb-list and the hash.  Making
sure objects are fully set up before adding to a list is always a good
idea, and really has nothing to do with RCU.

