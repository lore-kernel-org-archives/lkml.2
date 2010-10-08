Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0JHHdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:33:08 -0400
Received: from canuck.infradead.org ([134.117.69.58]:46483 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab0JHHdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:33:07 -0400
Date: Fri, 8 Oct 2010 03:33:06 -0400
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101008073306.GD7831@lst.de>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-12-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:25PM +1100, Dave Chinner wrote:
> From: Nick Piggin <npiggin@suse.de>
> 
> Protect the inod hash with a single lock is not scalable.  Convert

s/inod/inode/

>  	p = &root->inode_tree.rb_node;
>  	parent = NULL;
>  
> -	if (hlist_unhashed(&inode->i_hash))
> +	if (hlist_bl_unhashed(&inode->i_hash))

Maybe introduce an inode_unhashed helper for this check which we're
doing in quite a lot of places?

Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
