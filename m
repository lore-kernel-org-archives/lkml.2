Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2JJBlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:41:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57561 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab2JJBlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:41:49 -0400
MIME-Version: 1.0
In-Reply-To: <1349813638-4617-8-git-send-email-arnd@arndb.de>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de> <1349813638-4617-8-git-send-email-arnd@arndb.de>
From: Wan ZongShun <mcuos.com@gmail.com>
Date: Wed, 10 Oct 2012 09:41:27 +0800
Message-ID: <CAKT61h_4UqKN-cSPFL=P5W9pFzu219hTiMY9LQr_WtvbVCGMAg@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] video: mark nuc900fb_map_video_memory as __devinit
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/10 Arnd Bergmann <arnd@arndb.de>:
> nuc900fb_map_video_memory is called by an devinit function
> that may be called at run-time, but the function itself is
> marked __init and will be discarded after boot.
>
> To avoid calling into a function that may have been overwritten,
> mark nuc900fb_map_video_memory itself as __devinit.
>
> Without this patch, building nuc950_defconfig results in:
>
> WARNING: drivers/video/built-in.o(.devinit.text+0x26c): Section mismatch in reference from the function nuc900fb_probe() to the function .init.text:nuc900fb_map_video_memory()
> The function __devinit nuc900fb_probe() references
> a function __init nuc900fb_map_video_memory().
> If nuc900fb_map_video_memory is only used by nuc900fb_probe then
> annotate nuc900fb_map_video_memory with a matching annotation.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Wan ZongShun <mcuos.com@gmail.com>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: linux-fbdev@vger.kernel.org

Thanks for your patch.
Acked-by: Wan ZongShun <mcuos.com@gmail.com>

> ---
>  drivers/video/nuc900fb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
> index e10f551..b31b12b 100644
> --- a/drivers/video/nuc900fb.c
> +++ b/drivers/video/nuc900fb.c
> @@ -387,7 +387,7 @@ static int nuc900fb_init_registers(struct fb_info *info)
>   *    The buffer should be a non-cached, non-buffered, memory region
>   *    to allow palette and pixel writes without flushing the cache.
>   */
> -static int __init nuc900fb_map_video_memory(struct fb_info *info)
> +static int __devinit nuc900fb_map_video_memory(struct fb_info *info)
>  {
>         struct nuc900fb_info *fbi = info->par;
>         dma_addr_t map_dma;
> --
> 1.7.10
>



-- 
Wan ZongShun.
www.mcuos.com
