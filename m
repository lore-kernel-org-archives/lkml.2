Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab1BKSmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:42:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:36174 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab1BKSmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:42:46 -0500
Date: Fri, 11 Feb 2011 10:29:49 -0800
From: Greg KH <gregkh@suse.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/3]: Staging: hv: Use native page allocation/free
 functions
Message-ID: <20110211182949.GA10751@suse.de>
References: <1297447140-21777-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297447140-21777-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 09:59:00AM -0800, K. Y. Srinivasan wrote:
> --- a/drivers/staging/hv/hv.c
> +++ b/drivers/staging/hv/hv.c
> @@ -230,7 +230,12 @@ int hv_init(void)
>  	* Allocate the hypercall page memory
>  	* virtaddr = osd_page_alloc(1);
>  	*/
> -	virtaddr = osd_virtual_alloc_exec(PAGE_SIZE);
> +#ifdef __x86_64__
> +	virtaddr = __vmalloc(PAGE_SIZE, GFP_KERNEL, PAGE_KERNEL_EXEC);
> +#else
> +	virtaddr =  __vmalloc(PAGE_SIZE, GFP_KERNEL,
> +			__pgprot(__PAGE_KERNEL & (~_PAGE_NX)));
> +#endif

I'm not saying this patch is wrong at all, but I still don't understand
why this is different depending on the architecture of the machine.  Why
is this necessary, it should be ok to do the same type of allocation no
matter what the processor is, right?

thanks,

greg k-h
