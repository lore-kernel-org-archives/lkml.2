Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab2FNLTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:19:20 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:38701 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754304Ab2FNLTS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:19:18 -0400
MIME-Version: 1.0
In-Reply-To: <1339669250-9183-16-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com> <1339669250-9183-16-git-send-email-balbi@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 14 Jun 2012 16:48:56 +0530
Message-ID: <CAMQu2gzbK+ObetarwRiEz9A7=awEffAhrMMAqSMfiv4H6BZAuw@mail.gmail.com>
Subject: Re: [PATCH 15/17] i2c: omap: always return IRQ_HANDLED
To: Felipe Balbi <balbi@ti.com>
Cc: ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 3:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> otherwise we could get our IRQ line disabled due
> to many spurious IRQs.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/i2c/busses/i2c-omap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index fc5b8bc..5b78a73 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -1015,7 +1015,7 @@ omap_i2c_isr(int this_irq, void *dev_id)
>                }
>        } while (stat);
>
> -       return count ? IRQ_HANDLED : IRQ_NONE;
> +       return IRQ_HANDLED;

no sure if this is correct. if you have IRQ flood and instead of _actually_
handling it, if you return handled, you still have interrupt pending, right?

 if (count++ == 100) {
                        dev_warn(dev->dev, "Too much work in one IRQ\n");
                        break;
                }
ofcourse we do get warning message already, so as such the change
should be fine.

Just want to understand the change bit more.

Regards
Santosh



Regards
santosh
