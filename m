Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0C2FeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 01:34:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37340 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0C2FeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 01:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tun1sLlVmS1etaTbUxtjHSxVC/jLWuTxG2PkSZWg/2tMCtGH7xLHxOdWoXQN9lLE0e
         PM2U8fdnC7BZXih2eOx0zWPTZyZZxjY+f9SEHqP+5gEAAMCy/Hk3b1IqICLNeiLHCKOn
         M7z+q+UIKN+QX059O8D4EE+eteD7H6LNamEFQ=
MIME-Version: 1.0
In-Reply-To: <1269794716-8154-1-git-send-email-maz@misterjones.org>
References: <1269794716-8154-1-git-send-email-maz@misterjones.org>
Date: Mon, 29 Mar 2010 07:34:20 +0200
X-Google-Sender-Auth: ec0461de5896eaae
Message-ID: <cabda6421003282234n22605573m243b6192b4f0eabe@mail.gmail.com>
Subject: Re: [PATCH] Add hotplug support to mcp251x driver
From: christian pellegrin <chripell@fsfe.org>
To: Marc Zyngier <maz@misterjones.org>,
       SocketCAN Core Mailing List <socketcan-core@lists.berlios.de>
Cc: linux-kernel@vger.kernel.org, Edwin Peer <epeer@tmtservices.co.za>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, it looks ok to me. Can you resend the patch to
socketcan-core@lists.berlios.de ml too? We try to keep the version
there synchronized as much as possible to that in mainline.

Thanks,

Acked-by: Christian Pellegrin <chripell@fsfe.org>

On Sun, Mar 28, 2010 at 6:45 PM, Marc Zyngier <maz@misterjones.org> wrote:
> Chip model can now be selected directly by matching the modalias name
> (instead of filling the .model field in platform_data), and allows the
> module to be auto-loaded. Previous behaviour is of course still supported.
>
> Convert the two in-tree users to this feature (icontrol & zeus).
> Tested on an Zeus platform (mcp2515).
>
> Signed-off-by: Marc Zyngier <maz@misterjones.org>
> Cc: Edwin Peer <epeer@tmtservices.co.za>
> Cc: Christian Pellegrin <chripell@fsfe.org>
> ---
>  arch/arm/mach-pxa/icontrol.c         |    9 ++++-----
>  arch/arm/mach-pxa/zeus.c             |    4 +---
>  drivers/net/can/mcp251x.c            |   14 ++++++++++++++
>  include/linux/can/platform/mcp251x.h |    4 ++--
>  4 files changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/icontrol.c b/arch/arm/mach-pxa/icontrol.c
> index 771137f..5ccb0ce 100644
> --- a/arch/arm/mach-pxa/icontrol.c
> +++ b/arch/arm/mach-pxa/icontrol.c
> @@ -73,7 +73,6 @@ static struct pxa2xx_spi_chip mcp251x_chip_info4 = {
>
>  static struct mcp251x_platform_data mcp251x_info = {
>        .oscillator_frequency = 16E6,
> -       .model                = CAN_MCP251X_MCP2515,
>        .board_specific_setup = NULL,
>        .power_enable         = NULL,
>        .transceiver_enable   = NULL
> @@ -81,7 +80,7 @@ static struct mcp251x_platform_data mcp251x_info = {
>
>  static struct spi_board_info mcp251x_board_info[] = {
>        {
> -               .modalias        = "mcp251x",
> +               .modalias        = "mcp2515",
>                .max_speed_hz    = 6500000,
>                .bus_num         = 3,
>                .chip_select     = 0,
> @@ -90,7 +89,7 @@ static struct spi_board_info mcp251x_board_info[] = {
>                .irq             = gpio_to_irq(ICONTROL_MCP251x_nIRQ1)
>        },
>        {
> -               .modalias        = "mcp251x",
> +               .modalias        = "mcp2515",
>                .max_speed_hz    = 6500000,
>                .bus_num         = 3,
>                .chip_select     = 1,
> @@ -99,7 +98,7 @@ static struct spi_board_info mcp251x_board_info[] = {
>                .irq             = gpio_to_irq(ICONTROL_MCP251x_nIRQ2)
>        },
>        {
> -               .modalias        = "mcp251x",
> +               .modalias        = "mcp2515",
>                .max_speed_hz    = 6500000,
>                .bus_num         = 4,
>                .chip_select     = 0,
> @@ -108,7 +107,7 @@ static struct spi_board_info mcp251x_board_info[] = {
>                .irq             = gpio_to_irq(ICONTROL_MCP251x_nIRQ3)
>        },
>        {
> -               .modalias        = "mcp251x",
> +               .modalias        = "mcp2515",
>                .max_speed_hz    = 6500000,
>                .bus_num         = 4,
>                .chip_select     = 1,
> diff --git a/arch/arm/mach-pxa/zeus.c b/arch/arm/mach-pxa/zeus.c
> index 39896d8..dbd2569 100644
> --- a/arch/arm/mach-pxa/zeus.c
> +++ b/arch/arm/mach-pxa/zeus.c
> @@ -414,15 +414,13 @@ static int zeus_mcp2515_transceiver_enable(int enable)
>
>  static struct mcp251x_platform_data zeus_mcp2515_pdata = {
>        .oscillator_frequency   = 16*1000*1000,
> -       .model                  = CAN_MCP251X_MCP2515,
>        .board_specific_setup   = zeus_mcp2515_setup,
> -       .transceiver_enable     = zeus_mcp2515_transceiver_enable,
>        .power_enable           = zeus_mcp2515_transceiver_enable,
>  };
>
>  static struct spi_board_info zeus_spi_board_info[] = {
>        [0] = {
> -               .modalias       = "mcp251x",
> +               .modalias       = "mcp2515",
>                .platform_data  = &zeus_mcp2515_pdata,
>                .irq            = gpio_to_irq(ZEUS_CAN_GPIO),
>                .max_speed_hz   = 1*1000*1000,
> diff --git a/drivers/net/can/mcp251x.c b/drivers/net/can/mcp251x.c
> index f8cc168..f521579 100644
> --- a/drivers/net/can/mcp251x.c
> +++ b/drivers/net/can/mcp251x.c
> @@ -922,12 +922,16 @@ static int __devinit mcp251x_can_probe(struct spi_device *spi)
>        struct net_device *net;
>        struct mcp251x_priv *priv;
>        struct mcp251x_platform_data *pdata = spi->dev.platform_data;
> +       int model = spi_get_device_id(spi)->driver_data;
>        int ret = -ENODEV;
>
>        if (!pdata)
>                /* Platform data is required for osc freq */
>                goto error_out;
>
> +       if (model)
> +               pdata->model = model;
> +
>        /* Allocate can/net device */
>        net = alloc_candev(sizeof(struct mcp251x_priv), TX_ECHO_SKB_MAX);
>        if (!net) {
> @@ -1117,6 +1121,15 @@ static int mcp251x_can_resume(struct spi_device *spi)
>  #define mcp251x_can_resume NULL
>  #endif
>
> +static struct spi_device_id mcp251x_id_table[] = {
> +       { "mcp251x",    0 /* Use pdata.model */ },
> +       { "mcp2510",    CAN_MCP251X_MCP2510 },
> +       { "mcp2515",    CAN_MCP251X_MCP2515 },
> +       { },
> +};
> +
> +MODULE_DEVICE_TABLE(spi, mcp251x_id_table);
> +
>  static struct spi_driver mcp251x_can_driver = {
>        .driver = {
>                .name = DEVICE_NAME,
> @@ -1124,6 +1137,7 @@ static struct spi_driver mcp251x_can_driver = {
>                .owner = THIS_MODULE,
>        },
>
> +       .id_table = mcp251x_id_table,
>        .probe = mcp251x_can_probe,
>        .remove = __devexit_p(mcp251x_can_remove),
>        .suspend = mcp251x_can_suspend,
> diff --git a/include/linux/can/platform/mcp251x.h b/include/linux/can/platform/mcp251x.h
> index 1448177..dba2826 100644
> --- a/include/linux/can/platform/mcp251x.h
> +++ b/include/linux/can/platform/mcp251x.h
> @@ -26,8 +26,8 @@
>  struct mcp251x_platform_data {
>        unsigned long oscillator_frequency;
>        int model;
> -#define CAN_MCP251X_MCP2510 0
> -#define CAN_MCP251X_MCP2515 1
> +#define CAN_MCP251X_MCP2510 0x2510
> +#define CAN_MCP251X_MCP2515 0x2515
>        int (*board_specific_setup)(struct spi_device *spi);
>        int (*transceiver_enable)(int enable);
>        int (*power_enable) (int enable);
> --
> 1.7.0.3
>
>



-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
