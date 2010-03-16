Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab0CPTHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 15:07:52 -0400
Received: from kroah.org ([198.145.64.141]:50260 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157Ab0CPTFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:05:42 -0400
Date: Tue, 16 Mar 2010 12:00:05 -0700
From: Greg KH <greg@kroah.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: kay.sievers@vrfy.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH] devtmpfs: support !CONFIG_TMPFS
Message-ID: <20100316190005.GA32555@kroah.com>
References: <1268389504-22179-1-git-send-email-jacmet@sunsite.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268389504-22179-1-git-send-email-jacmet@sunsite.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 11:25:04AM +0100, Peter Korsgaard wrote:
> Make devtmpfs available on (embedded) configurations without SHMEM/TMPFS,
> using ramfs instead.
> 
> Saves ~15KB.
> 
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
> ---
>  drivers/base/Kconfig    |    2 +-
>  drivers/base/devtmpfs.c |    5 +++++
>  fs/ramfs/inode.c        |    2 +-
>  include/linux/ramfs.h   |    2 ++
>  4 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index fd52c48..7e33b16 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -18,7 +18,7 @@ config UEVENT_HELPER_PATH
>  
>  config DEVTMPFS
>  	bool "Maintain a devtmpfs filesystem to mount at /dev"
> -	depends on HOTPLUG && SHMEM && TMPFS
> +	depends on HOTPLUG
>  	help
>  	  This creates a tmpfs filesystem instance early at bootup.
>  	  In this filesystem, the kernel driver core maintains device

With this patch, the Kconfig help text now is incorrect.
Is there a way to explicitly call out in the Kconfig which way devtmpfs
is being created?  How about a multiple selection that chooses either
TMPFS or RAMFS, with the default being TMPFS?

So care to redo this so that people can easily determine what is going
to happen easier than this patch currently causes?

thanks,

greg k-h
