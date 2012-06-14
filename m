Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab2FNKqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:46:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33365 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab2FNKqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:46:10 -0400
MIME-Version: 1.0
In-Reply-To: <1337225749-7106-1-git-send-email-ming.lei@canonical.com>
References: <1337225749-7106-1-git-send-email-ming.lei@canonical.com>
Date: Thu, 14 Jun 2012 18:46:07 +0800
Message-ID: <CACVXFVNtOQdsoD-v4BkyFXLPge7vgM-x+XYgESj8ksrQj=YfEA@mail.gmail.com>
Subject: Re: [PATCH -next] rtc-twl: pass IRQF_ONESHOT to request_threaded_irq
From: Ming Lei <ming.lei@canonical.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 11:35 AM, Ming Lei <ming.lei@canonical.com> wrote:
> The flag of IRQF_ONESHOT should be passed to request_threaded_irq,
> otherwise the following failure message will be dumped because
> hardware handler is defined as NULL:
>
> [    3.329864] genirq: Threaded irq requested with handler=NULL and
> !ONESHOT for irq 363
> [    3.338226] twl_rtc twl_rtc: IRQ is not free.
> [    3.346099] twl_rtc: probe of twl_rtc failed with error -22
>
> The patch fixes the rtc-twl probe failure.
>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/rtc/rtc-twl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
> index 258abea..c5d06fe 100644
> --- a/drivers/rtc/rtc-twl.c
> +++ b/drivers/rtc/rtc-twl.c
> @@ -510,7 +510,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
>        }
>
>        ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
> -                                  IRQF_TRIGGER_RISING,
> +                                  IRQF_TRIGGER_RISING | IRQF_ONESHOT,
>                                   dev_name(&rtc->dev), rtc);
>        if (ret < 0) {
>                dev_err(&pdev->dev, "IRQ is not free.\n");

Ping...

Without the patch, rtc can't be used on Pandaboard.

Thanks,
--
Ming Lei
