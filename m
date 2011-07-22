Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1GVWkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:40:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571Ab1GVWkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:40:09 -0400
Date: Fri, 22 Jul 2011 15:39:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephenmcameron@gmail.com,
        thenzl@redhat.com, mikem@beardog.cce.hp.com, stable@kernel.org
Subject: Re: [PATCH] hpsa: do not attempt to read from a write-only register
Message-Id: <20110722153956.e0b5da19.akpm@linux-foundation.org>
In-Reply-To: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 13:16:05 -0500
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Most smartarrays tolerate it, but a few new ones don't.
> Without this change some newer Smart Arrays will lock up
> and i/o will grind to a halt.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Cc: <stable@kernel.org>?

> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 6d8dcd4..7f53cea 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -214,7 +214,7 @@ static void SA5_submit_command(struct ctlr_info *h,
>  	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
>  		c->Header.Tag.lower);
>  	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
> -	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
> +	(void) readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
>  	h->commands_outstanding++;
>  	if (h->commands_outstanding > h->max_outstanding)
>  		h->max_outstanding = h->commands_outstanding;
