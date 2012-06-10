Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2FJPGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 11:06:52 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:54259 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2FJPGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 11:06:51 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.19.137]
In-Reply-To: <1338989907-25360-6-git-send-email-sjur.brandeland@stericsson.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com> <1338989907-25360-6-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 10 Jun 2012 18:06:30 +0300
Message-ID: <CAK=WgbZoDK2t-zRqAAb3_veN8EyFMBFj59AJiwd5xKivCqTOww@mail.gmail.com>
Subject: Re: [PATCH 5/7] remoteproc: Move Elf related functions to separate file
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 4:38 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Prepare for introduction of custom firmware loaders by
> moving all ELF related handling into a separate file.
> The functions: rproc_find_rsc_table(), rproc_fw_sanity_check(),
> rproc_find_rsc_table() and rproc_set_boot_addr() are moved
> to the new file remoteproc_elf_loader.c. No functional
> changes are introduced in this patch.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Very nice!

> @@ -165,7 +165,7 @@ static void rproc_disable_iommu(struct rproc *rproc)
>  * but only on kernel direct mapped RAM memory. Instead, we're just using
>  * here the output of the DMA API, which should be more correct.
>  */
> -static void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
> +void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)

Can be nice to shortly mention this change in the commit log too.

> diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
> +int
> +rproc_load_segments(struct rproc *rproc, const struct firmware *fw);
> +struct resource_table *
> +rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
> +                                                               int *tablesz);
> +int
> +rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw);
> +void rproc_set_boot_addr(struct rproc *rproc, const struct firmware *fw);
...
> +void *rproc_da_to_va(struct rproc *rproc, u64 da, int len);

remoteproc_internal.h might be a better place for these, I think,
because it's not exposed to the users.

Thanks,
Ohad.
