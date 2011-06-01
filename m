Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358Ab1FAR2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:28:52 -0400
Received: from mail.perches.com ([173.55.12.10]:2360 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759131Ab1FAR0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:17 -0400
Subject: Re: [PATCH 4/10] drivers/net/can/flexcan.c: add missing clk_put
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: Wolfgang Grandegger <wg@grandegger.com>, kernel-janitors@vger.kernel.org,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1306948213-20767-4-git-send-email-julia@diku.dk>
References: <1306948213-20767-4-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 10:26:15 -0700
Message-ID: <1306949175.32125.20.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 19:10 +0200, Julia Lawall wrote:
> The failed_get label is used after the call to clk_get has succeeded, so it
> should be moved up above the call to clk_put.
[]
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
[]
> @@ -978,8 +978,8 @@ static int __devinit flexcan_probe(struct platform_device *pdev)
>   failed_map:
>  	release_mem_region(mem->start, mem_size);
>   failed_req:
> -	clk_put(clk);
>   failed_get:
> +	clk_put(clk);
>   failed_clock:
>  	return err;

If this is correct, it might be better to rename all the
uses of failed_req to failed_get and delete label failed_req.

