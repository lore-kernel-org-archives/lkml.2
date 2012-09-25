Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2IYMrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:47:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44457 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2IYMrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:47:22 -0400
MIME-Version: 1.0
In-Reply-To: <1348563456-30569-2-git-send-email-inderpal.singh@linaro.org>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
	<1348563456-30569-2-git-send-email-inderpal.singh@linaro.org>
Date: Tue, 25 Sep 2012 18:17:22 +0530
Message-ID: <CABb+yY1DiWT6-faPe24wVYLwO9vP0W7KswcAyqAWd5VH-JfizA@mail.gmail.com>
Subject: Re: [PATCH 1/3] DMA: PL330: Free memory allocated for peripheral channels
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        boojin.kim@samsung.com, vinod.koul@intel.com, patches@linaro.org,
        kgene.kim@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 2:27 PM, Inderpal Singh
<inderpal.singh@linaro.org> wrote:
> The allocated memory for peripheral channels is not being freed upon
> failure in probe and in module's remove funtion. It will lead to memory
> leakage. Hence free the allocated memory.
>
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
> ---
>  drivers/dma/pl330.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 2ebd4cd..10c6b6a 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2962,7 +2962,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>         ret = dma_async_device_register(pd);
>         if (ret) {
>                 dev_err(&adev->dev, "unable to register DMAC\n");
> -               goto probe_err4;
> +               goto probe_err5;
>         }
>
Sorry this patch seems malformed. Against which tree did you prepare it ?

-jassi



>         dev_info(&adev->dev,
> @@ -2975,6 +2975,8 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>
>         return 0;
>
> +probe_err5:
> +       kfree(pdmac->peripherals);
>  probe_err4:
>         pl330_del(pi);
>  probe_err3:
> @@ -3025,6 +3027,7 @@ static int __devexit pl330_remove(struct amba_device *adev)
>         res = &adev->res;
>         release_mem_region(res->start, resource_size(res));
>
> +       kfree(pdmac->peripherals);
>         kfree(pdmac);
>
>         return 0;
> --
> 1.7.9.5
>
