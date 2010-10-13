Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0JML2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 07:28:30 -0400
Received: from canuck.infradead.org ([134.117.69.58]:53437 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab0JML23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 07:28:29 -0400
Date: Wed, 13 Oct 2010 07:28:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101013112827.GC16422@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013072701.GB3121@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013072701.GB3121@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 06:27:01PM +1100, Nick Piggin wrote:
> I'm happy to help to port the top of the patch set onto changes in
> earlier parts of it, but I would like the chance to do this really. I'm
> back in action now, so I can spend a lot of time catching up.

That's all good and fine, but it's really no reason for delaying getting
the most important bits in.  RCU path walk is all good and fine, and
I'm really looking forward to eventually see it.  But the basic
inode_lock and dcache_lock splits are fundamental work we need rather
sooner than later.  Additional candy ontop of that is fine but we'll
need a solid base.  Also note that having the locking split up, and
proper exported APIs instead of growling into dcache internals in
various filesystems means that we can start to look into replacing
the global inode and dcache hashes much more easily, and having
global data structures at least for the dcache is almost as bad
as having global locks.

