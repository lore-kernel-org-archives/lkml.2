Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab0FYPoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 11:44:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25025 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab0FYPn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 11:43:59 -0400
Date: Fri, 25 Jun 2010 08:43:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       David Woodhouse <David.Woodhouse@intel.com>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] staging/spectra: remove non existing blk_fs_request
 wrapper
Message-Id: <20100625084312.8199b158.randy.dunlap@oracle.com>
In-Reply-To: <1277440848.18981.9.camel@lenovo>
References: <1277440848.18981.9.camel@lenovo>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C24CEB7.00D1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010 00:40:48 -0400 Javier Martinez Canillas wrote:

> The spectra driver doesn't compile with today linux-next
> 
> The problem is that it tries to use a blk_fs_request macro. Searching for this macro I saw that it used to exist in linux/blkdev.h as
> 
> #define blk_fs_request(rq) ((rq)->cmd_type == REQ_TYPE_FS)
> 
> This patch solves the issue eliminating the unnecessary (and now inexistent) wrapper
> 
> Best regards,
> 
> >From 755f948d65ff67d5dc8dde8c2edd212cbe61bd5f Mon Sep 17 00:00:00 2001
> From: Javier Martinez Canillas <martinez.javier@gmail.com>
> Date: Fri, 25 Jun 2010 00:26:20 -0400
> Subject: [PATCH] staging/spectra: remove non existing blk_fs_request wrapper
> 
> 
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  drivers/staging/spectra/ffsport.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/spectra/ffsport.c b/drivers/staging/spectra/ffsport.c
> index 3c3565d..d0c5c97 100644
> --- a/drivers/staging/spectra/ffsport.c
> +++ b/drivers/staging/spectra/ffsport.c
> @@ -304,7 +304,7 @@ static int do_transfer(struct spectra_nand_dev *tr, struct request *req)
>  			return 0;
>  	}
>  
> -	if (!blk_fs_request(req))
> +	if (req->cmd_type != REQ_TYPE_FS)
>  		return -EIO;
>  
>  	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) > get_capacity(tr->gd)) {
> -- 
> 1.7.0.4
> 
> 
> 
> 
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
