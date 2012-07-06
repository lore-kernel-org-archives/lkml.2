Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab2GFBnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 21:43:20 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:48964 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932161Ab2GFBnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 21:43:17 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>, Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldv-project@ispras.ru" <ldv-project@ispras.ru>
Date: Thu, 5 Jul 2012 18:40:31 -0700
Subject: RE: [PATCH] usb: gadget: mv_udc: use GFP_ATOMIC in build_dtd()
Thread-Topic: [PATCH] usb: gadget: mv_udc: use GFP_ATOMIC in build_dtd()
Thread-Index: Ac1bA02fC7/Xt/SURVSlYXnT77LOAgAEQj/g
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE1A1857A496@SC-VEXCH4.marvell.com>
References: <1341529788-10232-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1341529788-10232-1-git-send-email-khoroshilov@ispras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q661hSDL032292

Hi Alexey,
> -----Original Message-----
> From: Alexey Khoroshilov [mailto:khoroshilov@ispras.ru]
> Sent: 2012Äê7ÔÂ6ÈÕ 7:10
> To: Neil Zhang; Felipe Balbi
> Cc: Alexey Khoroshilov; Greg Kroah-Hartman; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; ldv-project@ispras.ru
> Subject: [PATCH] usb: gadget: mv_udc: use GFP_ATOMIC in build_dtd()
> 
> build_dtd() is called either from interrupt handler mv_udc_irq()
> or with spinlock held (from mv_ep_queue()). So we should
> alloc memory with GFP_ATOMIC, not GFP_KERNEL.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/usb/gadget/mv_udc_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/mv_udc_core.c
> b/drivers/usb/gadget/mv_udc_core.c
> index 117a4bb..693e1e4 100644
> --- a/drivers/usb/gadget/mv_udc_core.c
> +++ b/drivers/usb/gadget/mv_udc_core.c
> @@ -374,7 +374,7 @@ static struct mv_dtd *build_dtd(struct mv_req *req,
> unsigned *length,
>  	 * Be careful that no _GFP_HIGHMEM is set,
>  	 * or we can not use dma_to_virt
>  	 */
> -	dtd = dma_pool_alloc(udc->dtd_pool, GFP_KERNEL, dma);
> +	dtd = dma_pool_alloc(udc->dtd_pool, GFP_ATOMIC, dma);
>  	if (dtd == NULL)
>  		return dtd;
> 
> --
> 1.7.9.5

Thanks for your finding.
Actually we have found the issue some months ago and I would like to add some error handler if it failed to alloc memory.
I will sent out the patches soon.
Thanks.

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
