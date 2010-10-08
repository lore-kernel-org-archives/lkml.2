Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0JHIHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:07:02 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:60943 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752490Ab0JHIG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:06:59 -0400
Date: Fri, 8 Oct 2010 19:06:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/18] fs: Make iunique independent of inode_lock
Message-ID: <20101008080655.GY4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-17-git-send-email-david@fromorbit.com>
 <20101008075524.GB30902@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008075524.GB30902@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 03:55:24AM -0400, Christoph Hellwig wrote:
> > +	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
> > +		if (inode->i_ino == ino && inode->i_sb == sb) {
> 
> wouldn't it be more natural to test the sb first here?

Maybe, but I think an inode number match is less likely, so the
order it currently does the check results in less code being
executed on misses. I'll have a look at the rest of the code and do
whatever order they do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
