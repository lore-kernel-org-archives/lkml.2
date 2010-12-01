Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab0LATh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:37:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab0LATh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:37:28 -0500
Date: Wed, 1 Dec 2010 11:37:12 -0800
From: Greg KH <gregkh@suse.de>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] USB: whci-hcd: move whci_hcd_id_table under #ifdef
 MODULE
Message-ID: <20101201193712.GA918@suse.de>
References: <1291225529-1118-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291225529-1118-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 02:45:27AM +0900, Namhyung Kim wrote:
> Since whci_hcd_id_table is used only for module auto-loading
> move it under #ifdef MODULE. This fixes following warning:
> 
>   CC      drivers/usb/host/whci/hcd.o
> drivers/usb/host/whci/hcd.c:359: warning: ‘whci_hcd_id_table’ defined but not used
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/usb/host/whci/hcd.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/whci/hcd.c b/drivers/usb/host/whci/hcd.c
> index 72b6892..ee76401 100644
> --- a/drivers/usb/host/whci/hcd.c
> +++ b/drivers/usb/host/whci/hcd.c
> @@ -355,12 +355,14 @@ static void __exit whci_hc_driver_exit(void)
>  }
>  module_exit(whci_hc_driver_exit);
>  
> +#ifdef MODULE

Ick, no, please just use the __used type instead.  We don't want #ifdefs
in .c files if at all possible.

Same goes for the other 2 patches, care to redo them as well?

thanks,

greg k-h
