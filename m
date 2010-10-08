Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0JHITI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:19:08 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33133 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab0JHITG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:19:06 -0400
Date: Fri, 8 Oct 2010 04:19:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/18] fs: Make iunique independent of inode_lock
Message-ID: <20101008081905.GC17577@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-17-git-send-email-david@fromorbit.com>
 <20101008075524.GB30902@infradead.org>
 <20101008080655.GY4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008080655.GY4681@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 07:06:55PM +1100, Dave Chinner wrote:
> On Fri, Oct 08, 2010 at 03:55:24AM -0400, Christoph Hellwig wrote:
> > > +	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
> > > +		if (inode->i_ino == ino && inode->i_sb == sb) {
> > 
> > wouldn't it be more natural to test the sb first here?
> 
> Maybe, but I think an inode number match is less likely, so the
> order it currently does the check results in less code being
> executed on misses.

Ok, sounds fine.

