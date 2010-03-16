Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab0CPUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:16:57 -0400
Received: from kroah.org ([198.145.64.141]:38288 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840Ab0CPUQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:16:56 -0400
Date: Tue, 16 Mar 2010 13:17:20 -0700
From: Greg KH <greg@kroah.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: kay.sievers@vrfy.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH] devtmpfs: support !CONFIG_TMPFS
Message-ID: <20100316201720.GA11832@kroah.com>
References: <1268389504-22179-1-git-send-email-jacmet@sunsite.dk> <20100316190005.GA32555@kroah.com> <87wrxcgjuq.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wrxcgjuq.fsf@macbook.be.48ers.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 08:14:05PM +0100, Peter Korsgaard wrote:
> >>>>> "Greg" == Greg KH <greg@kroah.com> writes:
> 
> Hi,
> 
>  >> config DEVTMPFS
>  >> bool "Maintain a devtmpfs filesystem to mount at /dev"
>  >> -	depends on HOTPLUG && SHMEM && TMPFS
>  >> +	depends on HOTPLUG
>  >> help
>  >> This creates a tmpfs filesystem instance early at bootup.
>  >> In this filesystem, the kernel driver core maintains device
> 
>  Greg> With this patch, the Kconfig help text now is incorrect.
> 
>  Greg> Is there a way to explicitly call out in the Kconfig which way
>  Greg> devtmpfs is being created?  How about a multiple selection that
>  Greg> chooses either TMPFS or RAMFS, with the default being TMPFS?
> 
> I don't think that's needed - If CONFIG_TMPFS isn't set, then ramfs
> pretends to be tmpfs anyway, see mm/shmem.c:
> 
> static struct file_system_type tmpfs_fs_type = {
> 	.name		= "tmpfs",
> 	.get_sb		= ramfs_get_sb,
> 	.kill_sb	= kill_litter_super,
> };
> 
> So calling it tmpfs isn't really wrong.

Heh, wow, I didn't realize that.

>  Greg> So care to redo this so that people can easily determine what is going
>  Greg> to happen easier than this patch currently causes?
> 
> We can change the help text to say tmpfs/ramfs if you prefer - OK?

Yes, maybe with an explaination that if TMPFS is not set, ramfs will be
used.

thanks,

greg k-h
