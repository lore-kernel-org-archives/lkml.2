Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0I3EwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:52:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824Ab0I3Ev6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:51:58 -0400
Date: Wed, 29 Sep 2010 21:53:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/17] fs: Make last_ino, iunique independent of
 inode_lock
Message-Id: <20100929215302.1f4536be.akpm@linux-foundation.org>
In-Reply-To: <1285762729-17928-10-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-10-git-send-email-david@fromorbit.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 22:18:41 +1000 Dave Chinner <david@fromorbit.com> wrote:

> From: Nick Piggin <npiggin@suse.de>
> 
> Before removing the inode_lock, we need to make the last_ino  and iunique
> counters independent of the inode_lock. last_ino can be trivially converted to
> an atomic variable, while the iunique counter needs a new lock nested inside
> the inode_lock to provide the same protection that the inode_lock previously
> provided.
> 
>
> ...
>
> +static int test_inode_iunique(struct super_block * sb, struct hlist_head *head, unsigned long ino)
> +{
> +	struct hlist_node *node;
> +	struct inode * inode = NULL;
> +
> +	spin_lock(&inode_hash_lock);
> +	hlist_for_each_entry(inode, node, head, i_hash) {
> +		if (inode->i_ino == ino && inode->i_sb == sb) {
> +			spin_unlock(&inode_hash_lock);
> +			return 0;
> +		}
> +	}
> +	spin_unlock(&inode_hash_lock);
> +	return 1;
> +}

Please run all the patches through checkpatch.

Please document this function.  Why does it exist?  What does it do? 
How does it do it?  Try to improve the code!

>
> ...
>

