Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab2JJMgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:36:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33246 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754084Ab2JJMgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:36:13 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/zM68Dy2PzX2dzR4Zx80YpnYMJH4TA4aANoM2bPy
	3UhqyLtaKcs+Eq
Message-ID: <50756BB0.20005@gmx.de>
Date: Wed, 10 Oct 2012 12:36:00 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 7/8] video: mark nuc900fb_map_video_memory as __devinit
References: <1349813638-4617-1-git-send-email-arnd@arndb.de> <1349813638-4617-8-git-send-email-arnd@arndb.de>
In-Reply-To: <1349813638-4617-8-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 08:13 PM, Arnd Bergmann wrote:
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

Applied.


Thanks,

Florian Tobias Schandinat

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
>  	struct nuc900fb_info *fbi = info->par;
>  	dma_addr_t map_dma;

