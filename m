Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab1HJGBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:01:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60044 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1HJGBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 02:01:49 -0400
Message-ID: <4E421EC7.6090505@gmail.com>
Date: Wed, 10 Aug 2011 16:01:43 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Jiandong Zheng <jdzheng@broadcom.com>, kernel-janitors@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mtd/nand/bcm_umi_nand.c: add missing kfree/ioremap
References: <1312954935-14592-1-git-send-email-julia@diku.dk>
In-Reply-To: <1312954935-14592-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/11 15:42, Julia Lawall wrote:
> From: Julia Lawall<julia@diku.dk>
>
> The error handling code under the #if should be the same as elsewhere in
> the function.
>
> Signed-off-by: Julia Lawall<julia@diku.dk>
>
> ---
>   drivers/mtd/nand/bcm_umi_nand.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
> index a8ae898..72e8ec2 100644
> --- a/drivers/mtd/nand/bcm_umi_nand.c
> +++ b/drivers/mtd/nand/bcm_umi_nand.c
> @@ -433,8 +433,11 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
>
>   #if USE_DMA
>   	err = nand_dma_init();
> -	if (err != 0)
> +	if (err != 0) {
> +		iounmap(bcm_umi_io_base);
> +		kfree(board_mtd);
>   		return err;
> +	}
>   #endif

This probe function should possibly use goto exits on failure. It 
reduces a bit of code duplication and helps prevent this type of error.

~Ryan

