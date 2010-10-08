Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab0JHTKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:10:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489Ab0JHTKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:10:52 -0400
Date: Fri, 8 Oct 2010 15:10:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101008191047.GA29976@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
 <20101008095658.GA19804@ZenIV.linux.org.uk>
 <20101008100346.GA27737@infradead.org>
 <1286533219.2959.128.camel@edumazet-laptop>
 <20101008134821.GA15157@infradead.org>
 <1286546772.2959.372.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286546772.2959.372.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:06:12PM +0200, Eric Dumazet wrote:
> On 32bit arches, inum for sockets/pipes could be pretty fast
> 
> unsigned u32 rnd_val __read_mostly; /* seeded at boot time */
> 
> unsigned u32 get_inum(struct inode *ino, size_t size)
> {
> 	return rnd_val ^ ((long)ino + random32() % size);
> }
> 
> (Ie , use fact that an inode is a kernel object, with a given address
> and a given size, two inodes cannot overlap)

Yeah, we could probably do this.  From looking at the remaining users
of the last_ino replacement this could probably work for them.

