Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab1C3W3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:29:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50084 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1C3W3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:29:13 -0400
Date: Wed, 30 Mar 2011 18:29:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Merge window closed - 2.6.39-rc1 out
Message-ID: <20110330222909.GA26174@infradead.org>
References: <AANLkTikwbY5mm10ZWg7B6XeSBkZXFqKcYVZfJCi2QGx_@mail.gmail.com>
 <20110330120151.GA23358@infradead.org>
 <20110330144359.GA16430@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330144359.GA16430@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 (1) it still has the totally stupid interface of a global dispatch table.
     Either it does make sense to have different providers, in which
     case you want the dispatch table on a per-superblock or whatever
     granularity, or you really want just one and can have static calls
     into it, and get rid of this whole layer
 (2) it still requires totally pointless calls from local filesystem to
     initialize a pool ID.  The filesystem really should not need to
     care about any of this.
 (3) it's still lacking a good user submitted with it.  And with that
     I don't mean junk code shoved into staging where it's bitrotting.

It also has an entirely new bug, in that it assumes every inode has
a dentry on the alias list.  Did you only ever test this with filesystem
that do not have export operations?  Otherwise the no-dentry case should
be fairly trivial to trigger due the placement of the hooks.

And of course there's still no convincing use case for all of this.

