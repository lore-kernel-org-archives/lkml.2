Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0JPQfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:35:20 -0400
Received: from canuck.infradead.org ([134.117.69.58]:56209 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0JPQfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:35:19 -0400
Date: Sat, 16 Oct 2010 12:35:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/19] fs: do not assign default i_ino in new_inode
Message-ID: <20101016163517.GF20086@infradead.org>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-20-git-send-email-david@fromorbit.com>
 <1287220153.2799.101.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287220153.2799.101.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 11:09:13AM +0200, Eric Dumazet wrote:
> I wonder if adding a flag in super_block to explicitely say :
> 
> "I dont need new_inode() allocates a i_ino for my new inode, because
> I'll take care of this myself later"
> 
> would be safer, permiting each fs maintainer to assert the flag instead
> of a single patch.

What's the point, really?  Assigning i_ino in new_inode always has been
an utterly stupid idea to start with.  I fixed the few filesystem that
need it to do it explicitly.  There's nothing unsafe about it - checking
callers of new_inode for manual i_ino assignment was trivial.

Conditional code like the one you suggested is simply evil - it
complicates things instead of simplifying them.
