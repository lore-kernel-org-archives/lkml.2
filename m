Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0JWJdE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 05:33:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48288 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0JWJdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 05:33:03 -0400
Date: Sat, 23 Oct 2010 10:32:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/21] fs: Implement lazy LRU updates for inodes
Message-ID: <20101023093259.GL19804@ZenIV.linux.org.uk>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287622186-1935-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 11:49:29AM +1100, Dave Chinner wrote:
>  		if (sb->s_flags & MS_ACTIVE) {
> +			inode->i_state |= I_REFERENCED;
> +			if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
> +				list_del_init(&inode->i_list);
> +				inode_lru_list_add(inode);

What if it was on the list already?  Looks like you'll screw the counter...
And yes, you have solution later in series (do nothing if list isn't empty);
should be here for bisectability sake...
