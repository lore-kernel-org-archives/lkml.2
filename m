Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab2BARlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:41:14 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45382 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab2BARlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:41:11 -0500
MIME-Version: 1.0
In-Reply-To: <1328053058-30752-1-git-send-email-mchehab@redhat.com>
References: <1328053058-30752-1-git-send-email-mchehab@redhat.com>
Date: Wed, 1 Feb 2012 12:41:10 -0500
Message-ID: <CA+5PVA6oGQOouEPxUds8jWM9hccJDikC2veoo1nf6HbWgnVzbQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] edac/ppc4xx_edac: Fix compilation
From: Josh Boyer <jwboyer@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 6:37 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> It seems that nobody is cross-compiling for this arch anymore...
>
> drivers/edac/ppc4xx_edac.c: In function 'ppc4xx_edac_probe':
> drivers/edac/ppc4xx_edac.c:188:12: error: storage class specified for parameter 'ppc4xx_edac_remove'
> ...
> drivers/edac/ppc4xx_edac.c:1068:19: error: 'match' undeclared (first use in this function)
> drivers/edac/ppc4xx_edac.c:1068:19: note: each undeclared identifier is reported only once for each function it appears in
> drivers/edac/ppc4xx_edac.c:1068:36: warning: left-hand operand of comma expression has no effect [-Wunused-value]

Ugh.  The linux-next tree builds ppc44x_defconfig daily, but I don't
have this module enabled there.  I'll get it added.

>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Josh Boyer <jwboyer@gmail.com>

> ---
>  drivers/edac/ppc4xx_edac.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
> index 0f06f14..1adaddf 100644
> --- a/drivers/edac/ppc4xx_edac.c
> +++ b/drivers/edac/ppc4xx_edac.c
> @@ -184,7 +184,7 @@ struct ppc4xx_ecc_status {
>
>  /* Function Prototypes */
>
> -static int ppc4xx_edac_probe(struct platform_device *device)
> +static int ppc4xx_edac_probe(struct platform_device *device);
>  static int ppc4xx_edac_remove(struct platform_device *device);
>
>  /* Global Variables */
> @@ -1065,7 +1065,7 @@ ppc4xx_edac_mc_init(struct mem_ctl_info *mci,
>
>        mci->mod_name           = PPC4XX_EDAC_MODULE_NAME;
>        mci->mod_ver            = PPC4XX_EDAC_MODULE_REVISION;
> -       mci->ctl_name           = match->compatible,
> +       mci->ctl_name           = ppc4xx_edac_match->compatible,
>        mci->dev_name           = np->full_name;
>
>        /* Initialize callbacks */
> --
> 1.7.8
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
