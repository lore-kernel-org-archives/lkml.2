Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab0JHJQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:16:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56059 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0JHJQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:16:18 -0400
Date: Fri, 8 Oct 2010 10:16:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] fs: inode split IO and LRU lists
Message-ID: <20101008091617.GW19804@ZenIV.linux.org.uk>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-6-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	struct list_head	i_list;		/* backing dev IO list */
> +	struct list_head	i_io;		/* backing dev IO list */
> +	struct list_head	i_lru;		/* backing dev IO list */

a) that pair of comments would be disqualified in IOCCC ;-)
b) have a pity on folks who will have to talk about the code.  I mean,
how would you say that?  Ai-Ai-Oh?

> +extern struct percpu_counter nr_inodes;
> +extern struct percpu_counter nr_inodes_unused;

Ehh...  At least take that to fs/internal.h.  Preferably don't expose at
all.

> -				list_del(&inode->i_list);
> -				list_add(&inode->i_list, &bdi->wb.b_dirty);
> +				list_del(&inode->i_io);
> +				list_add(&inode->i_io, &bdi->wb.b_dirty);

list_move()?  Ditto for the next few.  And, while that's not directed
at you, this kind of loops is Not Nice(tm)...
