Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab0E1UYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:24:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660Ab0E1UYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:24:03 -0400
Date: Fri, 28 May 2010 13:23:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>,
       "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
       Chris Mason <chris.mason@oracle.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-ext4@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       David Woodhouse <dwmw2@infradead.org>, reiserfs-devel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCHv4 01/17] VFS: introduce helpers for the s_dirty flag
Message-Id: <20100528132318.0783675a.akpm@linux-foundation.org>
In-Reply-To: <1274795352-3551-2-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	<1274795352-3551-2-git-send-email-dedekind1@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 16:48:56 +0300
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> This patch introduces 3 new VFS helpers: 'mark_sb_dirty()',
> 'mark_sb_clean()', and 'is_sb_dirty()'. The helpers simply
> set 'sb->s_dirt' or test 'sb->s_dirt'. The plan is to make
> every FS use these helpers instead of manipulating the
> 'sb->s_dirt' flag directly.
> 
> Ultimately, this change is a preparation for the periodic
> superblock synchronization optimization which is about
> preventing the "sync_supers" kernel thread from waking up
> even if there is nothing to synchronize.
> 
> This patch also makes VFS use the new helpers.

Patchset generally looks good to me.  But I don't like the names :(

> +static inline void mark_sb_dirty(struct super_block *sb)
> +{
> +	sb->s_dirt = 1;
> +}
> +static inline void mark_sb_clean(struct super_block *sb)
> +{
> +	sb->s_dirt = 0;
> +}
> +static inline int is_sb_dirty(struct super_block *sb)
> +{
> +	return sb->s_dirt;
> +}

A more conventional and superior naming scheme is
subsystemid_specific_function_identifier().  eg, bio_add_page() instead
of add_page_to_bio().

So these want to be sb_mark_dirty(), etc.

Being very old code written by very yound people, the VFS kinda ignores
that convention, but it doesn't hurt to use it for new code.

Feel free to ignore me if that's too much of a PITA ;)
