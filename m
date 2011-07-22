Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1GVWje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:39:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363Ab1GVWjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:39:33 -0400
Date: Fri, 22 Jul 2011 15:39:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: axboe@kernel.dk, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com, stable@kernel.org
Subject: Re: [PATCH] cciss: do not attempt to read from a write-only
 register
Message-Id: <20110722153919.ff53e0ae.akpm@linux-foundation.org>
In-Reply-To: <20110721181601.31646.18252.stgit@beardog.cce.hp.com>
References: <20110721181601.31646.18252.stgit@beardog.cce.hp.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 13:16:01 -0500
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Most smartarrays will tolerate it, but some new ones don't.
> Without this change some newer Smart Arrays will lock up
> and i/o will grind to a halt.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

No Cc: <stable@kernel.org>?

>  drivers/block/cciss.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
> index 16b4d58..c049548 100644
> --- a/drivers/block/cciss.h
> +++ b/drivers/block/cciss.h
> @@ -223,7 +223,7 @@ static void SA5_submit_command( ctlr_info_t *h, CommandList_struct *c)
>  			h->ctlr, c->busaddr);
>  #endif /* CCISS_DEBUG */
>           writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
> -	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
> +	readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
>  	 h->commands_outstanding++;
>  	 if ( h->commands_outstanding > h->max_outstanding)
>  		h->max_outstanding = h->commands_outstanding;
