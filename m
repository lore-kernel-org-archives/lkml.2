Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2GIUGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:06:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50303 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2GIUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:06:08 -0400
Date: Mon, 9 Jul 2012 13:06:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Lior Dotan <liodot@gmail.com>, Christopher Harrer <charrer@alacritech.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/3] staging/slicoss: disable pci device at remove
Message-ID: <20120709200604.GA2536@kroah.com>
References: <1341855260-9037-1-git-send-email-devendra.aaru@gmail.com>
 <1341855260-9037-2-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341855260-9037-2-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 11:04:19PM +0530, Devendra Naga wrote:
> at probe we enabled the device, and we should disable it at remove.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/staging/slicoss/slicoss.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
> index a511a2b..5bd3825 100644
> --- a/drivers/staging/slicoss/slicoss.c
> +++ b/drivers/staging/slicoss/slicoss.c
> @@ -3234,6 +3234,7 @@ static void __devexit slic_entry_remove(struct pci_dev *pcidev)
>  	}
>  	free_netdev(dev);
>  	pci_release_regions(pcidev);
> +	pci_disable_device(pcidev);

No, you really shouldn't do this, see the many times this has come up on
the linux-kernel mailing list for why.

thanks,

greg k-h
