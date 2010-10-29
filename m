Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab0J2Js6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:48:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38071 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933656Ab0J2Js4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:48:56 -0400
Date: Fri, 29 Oct 2010 10:48:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] fs: move i_wb_list out from under inode_lock
Message-ID: <20101029094854.GS19804@ZenIV.linux.org.uk>
References: <1288342803-14957-1-git-send-email-david@fromorbit.com>
 <1288342803-14957-7-git-send-email-david@fromorbit.com>
 <20101029094358.GA9052@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029094358.GA9052@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 05:43:58AM -0400, Christoph Hellwig wrote:
> > -extern int evict_inodes(struct super_block *);
> > +extern void evict_inodes(struct super_block *);
> 
> err, evict_inodes doesn't change in this patch.

Erm...  That's my fuckup - it _is_ void(struct super_block *) and the
only reason why it doesn't blow up is that inode.c doesn't include
internal.h.

IOW, Dave is right and I'll fix that in a minute.
