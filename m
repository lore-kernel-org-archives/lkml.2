Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2LUC1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:27:33 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:40384 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2LUC10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:27:26 -0500
Date: Fri, 21 Dec 2012 04:19:49 +0200
From: Ido Yariv <ido@wizery.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjur@brendeland.net>
Subject: Re: [RFCv2 09/11] remoteproc: Add operation to find resource table
 in memory
Message-ID: <20121221021948.GF28692@WorkStation.localnet>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-10-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355501220-4572-10-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Dec 14, 2012 at 05:06:58PM +0100, Sjur Brændeland wrote:
> Add function find_rsc_table_va to firmware ops. This function
> returns the location of the resource table in shared memory
> after loading.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
>  drivers/remoteproc/remoteproc_elf_loader.c |   16 ++++++++++-
>  drivers/remoteproc/remoteproc_internal.h   |   13 ++++++++
>  drivers/remoteproc/ste_modem_rproc.c       |   43 +++++++++++++++++++---------
>  3 files changed, 57 insertions(+), 15 deletions(-)

Perhaps split this patch into two - one that adds the new firmware op
and another that modifies the ste driver?

> 
> diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
> index 69832d9..3f6e315 100644
> --- a/drivers/remoteproc/remoteproc_elf_loader.c
> +++ b/drivers/remoteproc/remoteproc_elf_loader.c
> @@ -306,9 +306,23 @@ rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
>  	return table;
>  }
>  
> +struct resource_table *rproc_elf_get_rsctab_addr(struct rproc *rproc,
> +						 const struct firmware *fw)
> +{
> +	struct elf32_shdr *shdr;
> +
> +	shdr = find_rsc_shdr(&rproc->dev, (struct elf32_hdr *)fw->data);
> +	if (!shdr)
> +		return NULL;

Instead of traversing the headers twice, perhaps we could save the
address and size in advance and use it here?

Thanks,
Ido.
