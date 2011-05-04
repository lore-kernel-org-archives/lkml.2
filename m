Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1EDLQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:16:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab1EDLQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:16:04 -0400
Message-ID: <4DC13566.5070203@redhat.com>
Date: Wed, 04 May 2011 13:15:50 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Subject: Re: [PATCH 01/16] hpsa: do readl after writel in main i/o path to
 ensure	commands don't get lost.
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com> <20110503195849.5478.13229.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503195849.5478.13229.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2011 09:58 PM, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> Apparently we've been doin it rong for a decade, but only lately do we
> run into problems.
>
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 621a153..98c97ca 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -212,6 +212,7 @@ static void SA5_submit_command(struct ctlr_info *h,
>  	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
>  		c->Header.Tag.lower);
>  	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
> +	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
>   
Hi,
a small nit -
the (void) ^ is I think not needed for gcc and isn't present in the cciss.h patch

Tomas

>  	h->commands_outstanding++;
>  	if (h->commands_outstanding > h->max_outstanding)
>  		h->max_outstanding = h->commands_outstanding;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

