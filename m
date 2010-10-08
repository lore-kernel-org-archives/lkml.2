Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0JHJIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:08:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59789 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab0JHJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:08:06 -0400
Date: Fri, 8 Oct 2010 10:08:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/18] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101008090802.GV19804@ZenIV.linux.org.uk>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:18PM +1100, Dave Chinner wrote:

>  void __iget(struct inode *inode)
>  {
> -	if (atomic_inc_return(&inode->i_count) != 1)
> -		return;
> -
> -	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
> -		list_move(&inode->i_list, &inode_in_use);
> -	percpu_counter_dec(&nr_inodes_unused);
> +	atomic_inc(&inode->i_count);
>  }

Umm...  Are you sure we don't rely on implict barriers present in the current
version?
