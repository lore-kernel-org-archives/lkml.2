Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab2BNAe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:34:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2BNAe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:34:27 -0500
Date: Mon, 13 Feb 2012 16:34:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dave@gnu.org
Cc: Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] locks: export device name
Message-Id: <20120213163425.dd9adfde.akpm@linux-foundation.org>
In-Reply-To: <1328907967.3138.1.camel@offbook>
References: <1328907967.3138.1.camel@offbook>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012 22:06:07 +0100
Davidlohr Bueso <dave@gnu.org> wrote:

> From: Davidlohr Bueso <dave@gnu.org>
> 
> The lslk(8) program has not been maintained for over a decade and has recently been rewritten as lslocks(8).
> It will be available for the next 2.22 release, in a couple of months. This is a good opportunity to delete
> that nasty WE_CAN_BREAK_LSLK_NOW and start exporting the device name instead of the maj:min numbers.
> 
> For backward compatibility the new version can be in charge of checking older kernel versions and parsing the old
> output if necessary.
> 
> ...
>
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -2199,15 +2199,8 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
>  			       : (fl->fl_type & F_WRLCK) ? "WRITE" : "READ ");
>  	}
>  	if (inode) {
> -#ifdef WE_CAN_BREAK_LSLK_NOW
>  		seq_printf(f, "%d %s:%ld ", fl_pid,
>  				inode->i_sb->s_id, inode->i_ino);
> -#else
> -		/* userspace relies on this representation of dev_t ;-( */
> -		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
> -				MAJOR(inode->i_sb->s_dev),
> -				MINOR(inode->i_sb->s_dev), inode->i_ino);
> -#endif
>  	} else {
>  		seq_printf(f, "%d <none>:0 ", fl_pid);
>  	}

I don't get it.  This is an immediate and non-back-compatible change to
the format of /proc/locks.  The only way this can avoid breaking things
is if there are no programs or scripts in use by anyone which use
this field.  What am I missing here?

