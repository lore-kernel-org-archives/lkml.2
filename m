Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1HZXQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:16:33 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40251 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1HZXQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:16:31 -0400
MIME-Version: 1.0
In-Reply-To: <86216CAF-2B76-4C5E-8077-68D535FEDBB9@marvell.com>
References: <86216CAF-2B76-4C5E-8077-68D535FEDBB9@marvell.com>
Date: Sat, 27 Aug 2011 07:16:30 +0800
Message-ID: <CAN1soZx1DU3eYwOJvMNF5jdNorkfWuLpBwk5eV5VA89Bw5d4rg@mail.gmail.com>
Subject: Re: [PATCH] power: max8925. remove support for irq bits that do not exist
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Philip Rakity <prakity@marvell.com>, cbou@mail.ru,
        David Woodhouse <dwmw2@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 6:27 AM, Philip Rakity <prakity@marvell.com> wrote:
>
> The max8925 cannot return usb status.  The bits
> -       [MAX8925_IRQ_VCHG_USB_OVP] = {
> -               .reg            = MAX8925_CHG_IRQ1,
> -               .mask_reg       = MAX8925_CHG_IRQ1_MASK,
> -               .offs           = 1 << 3,
> -       },
> -       [MAX8925_IRQ_VCHG_USB_F] =  {
> -               .reg            = MAX8925_CHG_IRQ1,
> -               .mask_reg       = MAX8925_CHG_IRQ1_MASK,
> -               .offs           = 1 << 4,
> -       },
> -       [MAX8925_IRQ_VCHG_USB_R] = {
> -               .reg            = MAX8925_CHG_IRQ1,
> -               .mask_reg       = MAX8925_CHG_IRQ1_MASK,
> -               .offs           = 1 << 5,
> -       },
>
> do not exist in the irq register.
>
> Signed-off-by: Philip Rakity <prakity@marvell.com>
> ---
>  drivers/mfd/max8925-core.c    |   15 ---------------
>  drivers/power/max8925_power.c |   13 -------------
>  include/linux/mfd/max8925.h   |    3 ---
>  3 files changed, 0 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
> index e1e59c9..ca881ef 100644
> --- a/drivers/mfd/max8925-core.c
> +++ b/drivers/mfd/max8925-core.c
> @@ -210,21 +210,6 @@ static struct max8925_irq_data max8925_irqs[] = {
>                .mask_reg       = MAX8925_CHG_IRQ1_MASK,
>                .offs           = 1 << 2,
>        },
> -       [MAX8925_IRQ_VCHG_USB_OVP] = {
> -               .reg            = MAX8925_CHG_IRQ1,
> -               .mask_reg       = MAX8925_CHG_IRQ1_MASK,
> -               .offs           = 1 << 3,
> -       },
> -       [MAX8925_IRQ_VCHG_USB_F] =  {
> -               .reg            = MAX8925_CHG_IRQ1,
> -               .mask_reg       = MAX8925_CHG_IRQ1_MASK,
> -               .offs           = 1 << 4,
> -       },
> -       [MAX8925_IRQ_VCHG_USB_R] = {
> -               .reg            = MAX8925_CHG_IRQ1,
> -               .mask_reg       = MAX8925_CHG_IRQ1_MASK,
> -               .offs           = 1 << 5,
> -       },
>        [MAX8925_IRQ_VCHG_THM_OK_R] = {
>                .reg            = MAX8925_CHG_IRQ2,
>                .mask_reg       = MAX8925_CHG_IRQ2_MASK,
> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
> index 5e4e046..377d1e6 100644
> --- a/drivers/power/max8925_power.c
> +++ b/drivers/power/max8925_power.c
> @@ -120,16 +120,6 @@ static irqreturn_t max8925_charger_handler(int irq, void *data)
>                __set_charger(info, 0);
>                dev_dbg(chip->dev, "Adapter removed\n");
>                break;
> -       case MAX8925_IRQ_VCHG_USB_R:
> -               info->usb_online = 1;
> -               __set_charger(info, 1);
> -               dev_dbg(chip->dev, "USB inserted\n");
> -               break;
> -       case MAX8925_IRQ_VCHG_USB_F:
> -               info->usb_online = 0;
> -               __set_charger(info, 0);
> -               dev_dbg(chip->dev, "USB removed\n");
> -               break;
>        case MAX8925_IRQ_VCHG_THM_OK_F:
>                /* Battery is not ready yet */
>                dev_dbg(chip->dev, "Battery temperature is out of range\n");
> @@ -370,9 +360,6 @@ static __devinit int max8925_init_charger(struct max8925_chip *chip,
>                REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_F, "ac-remove");
>                REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_R, "ac-insert");
>        }
> -       REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_OVP, "usb-ovp");
> -       REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_F, "usb-remove");
> -       REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_R, "usb-insert");
>        if (!info->no_temp_support) {
>                REQUEST_IRQ(MAX8925_IRQ_VCHG_THM_OK_R, "batt-temp-in-range");
>                REQUEST_IRQ(MAX8925_IRQ_VCHG_THM_OK_F, "batt-temp-out-range");
> diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
> index 008f807..b8e6d94 100644
> --- a/include/linux/mfd/max8925.h
> +++ b/include/linux/mfd/max8925.h
> @@ -167,9 +167,6 @@ enum {
>        MAX8925_IRQ_VCHG_DC_OVP,
>        MAX8925_IRQ_VCHG_DC_F,
>        MAX8925_IRQ_VCHG_DC_R,
> -       MAX8925_IRQ_VCHG_USB_OVP,
> -       MAX8925_IRQ_VCHG_USB_F,
> -       MAX8925_IRQ_VCHG_USB_R,
>        MAX8925_IRQ_VCHG_THM_OK_R,
>        MAX8925_IRQ_VCHG_THM_OK_F,
>        MAX8925_IRQ_VCHG_SYSLOW_F,
> --
> 1.7.6
>
>
>

Loop maintainer
