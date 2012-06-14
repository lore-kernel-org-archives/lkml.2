Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2FNLB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:01:28 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:54020 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074Ab2FNLB1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:01:27 -0400
MIME-Version: 1.0
In-Reply-To: <1339669250-9183-7-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com> <1339669250-9183-7-git-send-email-balbi@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 14 Jun 2012 16:31:02 +0530
Message-ID: <CAMQu2gxY6x+JFw1ncimpVSxutJ_+4zscGHzVpg85W-4SPfUJRQ@mail.gmail.com>
Subject: Re: [PATCH 06/17] i2c: omap: improve 1p153 errata handling
To: Felipe Balbi <balbi@ti.com>
Cc: ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 3:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> Make it not depend on ISR's local variables
> in order to make it easier to re-factor the
> transmit data loop.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/i2c/busses/i2c-omap.c |   47 +++++++++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 0661ca1..52861c2 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -768,21 +768,24 @@ omap_i2c_omap1_isr(int this_irq, void *dev_id)
>  * data to DATA_REG. Otherwise some data bytes can be lost while transferring
>  * them from the memory to the I2C interface.
>  */
> -static int errata_omap3_1p153(struct omap_i2c_dev *dev, u16 *stat, int *err)
> +static int errata_omap3_1p153(struct omap_i2c_dev *dev)
>  {
> -       unsigned long timeout = 10000;
> +       unsigned long   timeout = 10000;

Not related to this patch but this 10000 timeout magic
needs to be fixed as well.

The patch looks fine.

Regards
santosh
