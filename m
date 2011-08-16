Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab1HPRaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:30:08 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36140 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1HPRaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <1313515355-28920-1-git-send-email-fabio.estevam@freescale.com>
References: <1313515355-28920-1-git-send-email-fabio.estevam@freescale.com>
Date: Tue, 16 Aug 2011 13:30:06 -0400
Message-ID: <CACqU3MU2f17tb_5jjtT6TG0jw4P5JzR7=774QOoJ_T01wSmXHQ@mail.gmail.com>
Subject: Re: [PATCH] devtmpfs: Annotate devtmpfsd as __init
From: Arnaud Lacombe <lacombar@gmail.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 16, 2011 at 1:22 PM, Fabio Estevam
<fabio.estevam@freescale.com> wrote:
> This fixes the following:
>
> WARNING: vmlinux.o(.text+0x1ed41c): Section mismatch in reference from the function devtmpfsd() to the (unknown reference) .init.data:(unknown)
> The function devtmpfsd() references
> the (unknown reference) __initdata (unknown).
> This is often because devtmpfsd lacks a __initdata
> annotation or the annotation of (unknown) is wrong.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
I already submitted a patch for that https://patchwork.kernel.org/patch/996132/

> ---
>  drivers/base/devtmpfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
> index 33e1bed..7bd4860 100644
> --- a/drivers/base/devtmpfs.c
> +++ b/drivers/base/devtmpfs.c
> @@ -386,7 +386,7 @@ static int handle(const char *name, mode_t mode, struct device *dev)
>                return handle_remove(name, dev);
>  }
>
> -static int devtmpfsd(void *p)
> +static __init int devtmpfsd(void *p)
>  {
I think this is wrong. `devtmpfsd' is the main loop of the
process/thread, you certainly don't want to whip it after boot.

 - Arnaud

>        char options[] = "mode=0755";
>        int *err = p;
> --
> 1.6.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
