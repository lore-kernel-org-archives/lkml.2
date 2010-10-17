Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab0JQArq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:47:46 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33171 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab0JQAro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:47:44 -0400
Date: Sat, 16 Oct 2010 20:47:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/19] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101017004742.GD1614@infradead.org>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-5-git-send-email-david@fromorbit.com>
 <20101016092916.GA32197@amd>
 <20101016165930.GA20626@infradead.org>
 <20101016172924.GA3519@amd>
 <20101016173422.GA6840@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016173422.GA6840@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 04:34:22AM +1100, Nick Piggin wrote:
> > This might actually be the better approach anyway (even for upstream)
> > -- it means we don't have to worry about the "check head element"
> > heuristic of the LRU check which could get false negatives if there is
> > a lot of concurrency on the LRU.
> 
> Oh hmm, but then you do have the double lock of the LRU lock.
> 
> if (can_unuse_after_iput(inode)) {
>   spin_lock(&inode_lock);
>   list_move(inode, list tail)
>   spin_unlock(&inode_lock);
> }
> iput(inode);
> spin_lock(&inode_lock);
> 
> Is that worth it?

Probably not.
