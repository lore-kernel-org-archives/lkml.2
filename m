Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956Ab0IEGeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 02:34:20 -0400
Received: from kroah.org ([198.145.64.141]:45284 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0IEGeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 02:34:13 -0400
Date: Sat, 4 Sep 2010 22:20:49 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35, cyasgadget fixes
	and mpage_cleardirty
Message-ID: <20100905052049.GA4371@kroah.com>
References: <5BFACB1451C1459BA8562A5561D0A4E6@stanford.edu> <1283386101.17399.10.camel@odc-laptop> <1283467624.4378.14.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283467624.4378.14.camel@odc-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 03:47:04PM -0700, David Cross wrote:
> This patch contains update to the gadget driver, some of which are based on feedback from the Linux community concerning the usage of fat_get_block.
> It also contains the addition of mpage_clear_dirty, a function used to clear dirty pages from the page cache. These two patches are also interdependent
> and difficult to separate. As such, they are included as one patch.

Please wrap your lines at 72 columns.

And is this really hard to separate?  I can't take a patch that touches
anything outside of drivers/staging/ at the moment.

How about a patch here to fix up the locking issues, and the rest as a
separate patch?

Oh, you also added lines with trailing spaces and that's it, like the
following:

> @@ -1158,10 +1145,10 @@ static int cyasgadget_ioctl(
>  			cy_as_hal_print_message("%s: fhandle is OK, "
>  				"calling vfs_getattr\n", __func__);
>  			#endif
> -
> +			
>  			ret_stat = vfs_getattr(file_to_allocate->f_path.mnt,
>  				file_to_allocate->f_path.dentry, &stat);
> -
> +			
>  			#ifndef WESTBRIDGE_NDEBUG
>  			cy_as_hal_print_message("%s: returned from "
>  				"vfs_getattr() stat->blksize=0x%lx\n",

Why?  I think you might want to make sure your editor doesn't do this in
the future.

Also, if you ran your patch through the scripts/checkpatch.pl script, it
would have caught this error.

Care to redo it?

thanks,

greg k-h
