Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0JROsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:48:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49100 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab0JROsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:48:20 -0400
Date: Mon, 18 Oct 2010 10:48:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/19] fs: do not assign default i_ino in new_inode
Message-ID: <20101018144817.GA14369@infradead.org>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-20-git-send-email-david@fromorbit.com>
 <1287220153.2799.101.camel@edumazet-laptop>
 <20101016163517.GF20086@infradead.org>
 <1287393099.2409.8.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287393099.2409.8.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 11:11:39AM +0200, Eric Dumazet wrote:
> This is what we call code factorization. I wont call it evil.
> 
> If we want to change get_next_ino(void) implementation to 
> get_next_ino(struct inode *), or even get_next_inode(struct inode
> *inode, struct super_block *sb)
>  then we must go through all fs after your patch to add the new
> parameter.
> 
> I proposed an implementation on get_next_ino() on 32bit arches, with no
> per_cpu and shared counter, assuming we know the inode pointer. With
> your patch, it become very difficult to implement such an idea.

Why?  You now have all call sites that care and can trivially change
them to whatever argument they need.
