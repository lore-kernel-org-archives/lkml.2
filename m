Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab2IZQPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:15:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53153 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2IZQPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:15:44 -0400
Date: Wed, 26 Sep 2012 09:15:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] zram: select ZSMALLOC when ZRAM is configured
Message-ID: <20120926161539.GA30132@kroah.com>
References: <1348649419-16494-1-git-send-email-minchan@kernel.org>
 <1348649419-16494-4-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348649419-16494-4-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 05:50:19PM +0900, Minchan Kim wrote:
> At the monent, we can configure zram in driver/block once zsmalloc
> in /lib menu is configured firstly. It's not convenient.
> 
> User can configure zram in driver/block regardless of zsmalloc enabling
> by this patch.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/block/zram/Kconfig |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
> index be5abe8..ee23a86 100644
> --- a/drivers/block/zram/Kconfig
> +++ b/drivers/block/zram/Kconfig
> @@ -1,6 +1,7 @@
>  config ZRAM
>  	tristate "Compressed RAM block device support"
> -	depends on BLOCK && SYSFS && ZSMALLOC
> +	depends on BLOCK && SYSFS
> +	select ZSMALLOC

As ZSMALLOC is dependant on CONFIG_STAGING, this isn't going to work at
all, sorry.

If your code depends on staging code, we need to get the staging code
out of staging first, before this code can be moved out.

So please work to get zsmalloc cleaned up and merged out first please,
as it is, this patch series is not ok.

greg k-h
