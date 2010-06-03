Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0FCE6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:58:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43504 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0FCE6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:58:22 -0400
MIME-Version: 1.0
In-Reply-To: <1275537827-28921-1-git-send-email-w.sang@pengutronix.de>
References: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com> 
	<1275537827-28921-1-git-send-email-w.sang@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 2 Jun 2010 22:50:45 -0600
X-Google-Sender-Auth: BCtJIdN5q_uep1EAYJZLictWj8k
Message-ID: <AANLkTin3zq3wIoQrVcCd_1JjifarYhh2qm-lL0nKvNw6@mail.gmail.com>
Subject: Re: [PATCH 1/2] of/powerpc: fix fsl_msi device node pointer
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 10:03 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/powerpc/sysdev/fsl_msi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

Linus, I've also added this one to my tree.  Wolfram did an coccinelle
patch and hasn't found any more instances of this breakage.

g.

>
> diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
> index 0f5bee9..962c2d8 100644
> --- a/arch/powerpc/sysdev/fsl_msi.c
> +++ b/arch/powerpc/sysdev/fsl_msi.c
> @@ -347,7 +347,7 @@ static int __devinit fsl_of_msi_probe(struct of_device *dev,
>                goto error_out;
>        }
>        offset = 0;
> -       p = of_get_property(dev->node, "msi-available-ranges", &len);
> +       p = of_get_property(dev->dev.of_node, "msi-available-ranges", &len);
>        if (p)
>                offset = *p / IRQS_PER_MSI_REG;
>
> --
> 1.7.0
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
