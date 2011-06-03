Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1FCPEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:04:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62670 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab1FCPEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:04:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tn7wfuKJm5CIz/ue2GjN35nHO1MpK8ug4/M+i3bXsBMyHGYIwHn73LnmxY7FMRxfpj
         iHseePBkom0aPUcG18Zv4c3QZY9sFtgVenV61i1Ra9l+7MpZ6X5rUVJTw6SuAoWpiF5f
         UBIJ3kaH9oB3a2pkjxspIBrVnSH0OFWdVvtzA=
MIME-Version: 1.0
In-Reply-To: <1307106198-11965-1-git-send-email-zonque@gmail.com>
References: <1307106198-11965-1-git-send-email-zonque@gmail.com>
Date: Fri, 3 Jun 2011 23:04:39 +0800
Message-ID: <BANLkTimpLKkfSJbeuM6kc7bUE+JybTmVrA@mail.gmail.com>
Subject: Re: [PATCH] MTD: pxa3xx_nand: Fix blank page ECC mismatch
From: Lei Wen <adrian.wenl@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <David.Woodhouse@intel.com>,
        Lei Wen <leiwen@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>, stable@kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 9:03 PM, Daniel Mack <zonque@gmail.com> wrote:
> This bug was introduced in f8155a40 ("mtd: pxa3xx_nand: rework irq
> logic") and causes the PXA3xx NAND controller fail to operate with NAND
> flash that has empty pages. According to the comment in this block, the
> hardware controller will report a double-bit error for empty pages,
> which can and must be ignored.
>
> This patch restores the original behaviour of the driver.
>
> Signed-off-by: Daniel Mack <zonque@gmail.com>
> Cc: Lei Wen <leiwen@marvell.com>
> Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
> Cc: David Woodhouse <David.Woodhouse@intel.com>
> Cc: stable@kernel.org
> ---
>  drivers/mtd/nand/pxa3xx_nand.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> index 0c6ed72..60167d1 100644
> --- a/drivers/mtd/nand/pxa3xx_nand.c
> +++ b/drivers/mtd/nand/pxa3xx_nand.c
> @@ -687,6 +687,8 @@ static int pxa3xx_nand_read_page_hwecc(struct mtd_info *mtd,
>                 * OOB, ignore such double bit errors
>                 */
>                if (is_buf_blank(buf, mtd->writesize))
> +                       info->retcode = ERR_NONE;
> +               else
>                        mtd->ecc_stats.failed++;
>        }
>
> --
> 1.7.5.1
>

Acked-by: Lei Wen <leiwen@marvell.com>
