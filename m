Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2GaJjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:39:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39454 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab2GaJjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:39:10 -0400
Date: Tue, 31 Jul 2012 11:39:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] floppy: remove duplicated flag FD_RAW_NEED_DISK
In-Reply-To: <20120728114559.GA12184@localhost>
Message-ID: <alpine.LNX.2.00.1207311138430.30412@pobox.suse.cz>
References: <20120728114559.GA12184@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2012, Fengguang Wu wrote:

> Fix coccinelle warning (without behavior change):
> 
> drivers/block/floppy.c:2518:32-48: duplicated argument to & or |
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 553f43a..0fcbe14 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -2516,8 +2516,7 @@ static int make_raw_rw_request(void)
>  	set_fdc((long)current_req->rq_disk->private_data);
>  
>  	raw_cmd = &default_raw_cmd;
> -	raw_cmd->flags = FD_RAW_SPIN | FD_RAW_NEED_DISK | FD_RAW_NEED_DISK |
> -	    FD_RAW_NEED_SEEK;
> +	raw_cmd->flags = FD_RAW_SPIN | FD_RAW_NEED_DISK | FD_RAW_NEED_SEEK;
>  	raw_cmd->cmd_count = NR_RW;
>  	if (rq_data_dir(current_req) == READ) {
>  		raw_cmd->flags |= FD_RAW_READ;

Now that's a funny one. Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
