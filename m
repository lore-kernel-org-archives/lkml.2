Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0LYUu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 15:50:59 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49798 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0LYUu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 15:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SmC5vhg6CvoJATXU4DpSMMl8i0W+cpGmic8prkucCWHWSNpVgem6ixnVWsfQW/Cyus
         GTCuHp4SkE/suuqlpImTopHHrFgbT4qPdQqnbLcf+iAV5SM0C/KDEilOPDeR1CNWeuR+
         NdC6U8OtQ/OJ8CO+s7YzGnrKE2zeKYZR2F8b0=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012252125410.10759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012252125410.10759@swampdragon.chaosbits.net>
Date: Sat, 25 Dec 2010 21:50:56 +0100
Message-ID: <AANLkTi=Y4wDG6+AY1=8NuFLGuCidgqaU1LginfB1YpZH@mail.gmail.com>
Subject: Re: [PATCH] 3c59x: Don't assign when a comparison is intended
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: netdev@vger.kernel.org, vortex@scyld.com, becker@scyld.com,
        Steffen Klassert <klassert@mathematik.tu-chemnitz.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 9:30 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> Hi,
>
> In drivers/net/3c59x.c::vortex_probe1() we have this code:
>
>        if (gendev) {
>                if ((pdev = DEVICE_PCI(gendev))) {
>                        print_name = pci_name(pdev);
>                }
>
>                if ((edev = DEVICE_EISA(gendev))) {
>                        print_name = dev_name(&edev->dev);
>                }
>        }
>
> I believe these assignments were intended to be comparisons.
> If I'm correct, then here's a patch to fix that up.

I don't think so. Look at the extra brackets.

The code can also written as:

pdev = DEVICE_PCI(gendev);
if(pdev)
  print_name = pci_name(pdev);


>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  3c59x.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
> index 0a92436f..db8a80e 100644
> --- a/drivers/net/3c59x.c
> +++ b/drivers/net/3c59x.c
> @@ -1110,11 +1110,11 @@ static int __devinit vortex_probe1(struct device *gendev,
>        }
>
>        if (gendev) {
> -               if ((pdev = DEVICE_PCI(gendev))) {
> +               if ((pdev == DEVICE_PCI(gendev))) {
>                        print_name = pci_name(pdev);
>                }
>
> -               if ((edev = DEVICE_EISA(gendev))) {
> +               if ((edev == DEVICE_EISA(gendev))) {
>                        print_name = dev_name(&edev->dev);
>                }
>        }
>
>
> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Thanks,
//richard
