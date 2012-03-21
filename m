Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455Ab2CUVoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:44:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759136Ab2CUVod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:44:33 -0400
Date: Wed, 21 Mar 2012 14:44:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: axboe@kernel.dk, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com
Subject: Re: [PATCH] cciss: Initialize scsi host max_sectors for tape drive
 support
Message-Id: <20120321144431.044d3af3.akpm@linux-foundation.org>
In-Reply-To: <20120321213203.9277.11716.stgit@beardog.cce.hp.com>
References: <20120321213203.9277.11716.stgit@beardog.cce.hp.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 16:32:03 -0500
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> The default is too small

So is the changelog.

> (1024 blocks), use h->cciss_max_sectors (8192 blocks)

What problem does this patch solve?  What might be the user-visible
effects of the change?

> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/block/cciss_scsi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> index e820b68..f510a9c 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -866,6 +866,7 @@ cciss_scsi_detect(ctlr_info_t *h)
>  	sh->can_queue = cciss_tape_cmds;
>  	sh->sg_tablesize = h->maxsgentries;
>  	sh->max_cmd_len = MAX_COMMAND_SIZE;
> +	sh->max_sectors = h->cciss_max_sectors;
>  
>  	((struct cciss_scsi_adapter_data_t *) 
>  		h->scsi_ctlr)->scsi_host = sh;
