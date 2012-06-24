Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2FXODP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 10:03:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51697 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab2FXODN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 10:03:13 -0400
MIME-Version: 1.0
In-Reply-To: <1340545637-5449-5-git-send-email-stigge@antcom.de>
References: <1340545637-5449-1-git-send-email-stigge@antcom.de>
	<1340545637-5449-5-git-send-email-stigge@antcom.de>
Date: Sun, 24 Jun 2012 11:03:12 -0300
Message-ID: <CAAAP30Hav8ixYvfdbqwpEOwLFvXprpmLcXapiXq0aJfExTAh5A@mail.gmail.com>
Subject: Re: [PATCH 4/7] ARM: LPC32xx: Update DTS file for EA3250 board
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        rinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 10:47 AM, Roland Stigge <stigge@antcom.de> wrote:
> This DTS file update adds:
> * 3-channel ADC (for AD-IN on AD2, or 3-axis-accelerometer)
> * Interrupt key
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

> ---
>  arch/arm/boot/dts/ea3250.dts |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> --- linux-2.6.orig/arch/arm/boot/dts/ea3250.dts
> +++ linux-2.6/arch/arm/boot/dts/ea3250.dts
> @@ -152,6 +152,23 @@
>                        uart1: serial@40014000 {
>                                status = "okay";
>                        };
> +
> +                       /* 3-axis accelerometer X,Y,Z (or AD-IN instead of Z) */
> +                       adc@40048000 {
> +                               status = "okay";
> +                       };
> +               };
> +       };
> +
> +       gpio_keys {
> +               compatible = "gpio-keys";
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               autorepeat;
> +               button@21 {
> +                       label = "GPIO Key UP";
> +                       linux,code = <103>;
> +                       gpios = <&gpio 4 1 0>; /* GPI_P3 1 */
>                };
>        };
>  };
