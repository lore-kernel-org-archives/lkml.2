Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab0KXH7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 02:59:08 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54160 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab0KXH7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 02:59:05 -0500
Date: Wed, 24 Nov 2010 16:58:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Bird <tim.bird@am.sony.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 04/16 v4] pramfs: file operations
Message-ID: <20101124075818.GB2212@linux-sh.org>
References: <4CE79BD0.3030200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE79BD0.3030200@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 10:58:40AM +0100, Marco Stornelli wrote:
> diff -Nurp linux-2.6.36-orig/fs/pramfs/file.c linux-2.6.36/fs/pramfs/file.c
> --- linux-2.6.36-orig/fs/pramfs/file.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.36/fs/pramfs/file.c	2010-09-24 18:34:03.000000000 +0200
> @@ -0,0 +1,166 @@
> +/*
> + * FILE NAME fs/pramfs/file.c
> + *
> + * BRIEF DESCRIPTION
> + *
> + * File operations for files.
> + *
This FILE NAME / BRIEF DESCRIPTION thing should probably die, it's also
not used consistently throughout the series.

> +static int pram_open_file(struct inode *inode, struct file *filp)
> +{
> +#ifndef CONFIG_PRAMFS_XIP
> +	/* Without XIP we force to use Direct IO */
> +	filp->f_flags |= O_DIRECT;
> +#endif
> +	return generic_file_open(inode, filp);
> +}
> +
Relying on a config option for this is in violently poor taste. Rely on
the config option to enable/disable XIP support as you like, but whether
it's actually mounted XIP or not should really depend be determined by a
mount option. Presently you have no way of dealing with the file system
being mounted multiple times with mixed XIP and non-XIP, which doesn't
seem like a particularly exotic configuration. As you seem to have copied
most of this from ext2, I'm curious why you opted to hardcode this
instead of maintaining the flexibility that ext2 XIP has over this.
