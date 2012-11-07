Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2KGOQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:16:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63194 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2KGOQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:16:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC PATCH v1 25/31] ARC: [plat-arcfpga] Hooking up platform to ARC UART
Date: Wed, 7 Nov 2012 14:16:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-26-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352281674-2186-26-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211071416.08012.arnd@arndb.de>
X-Provags-ID: V02:K0:RGp7z1H0wJQncCUSyc+KK6r6DBdCg2ZSHS0rrz5HoCV
 ssCCl4/hJBOn14FOErmgR60g9q922SFXMkIXXUE+PPc/h8DjRx
 lKD3mk0+Ix9WfHgDCIQ9cJ12Pxn1SUUCpjjScgG4QInB6FMlES
 H5B8MvxqB2gZ9FKtBicaK+d6M6Dd3h5dAwH1kxAiT0TYtp7VL4
 kmQOaWgD+cj5b3pgw2BjM6ctXXehr3RhFkVHHyjeyGE3HTE2V8
 L50x8TKvjbK1fHuJ8jGsnkh/Z14tGTstkw8IdvDWtI18tL1Muo
 6J3NtZYJi3qIGwpo1gj95r3NV8hmZe9Yl6Immca0m4HG4cxjN8
 2Evb+FKhjp77ma4wVCvA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2012, Vineet Gupta wrote:
> +static struct platform_device arc_uart##n##_dev = {    \
> +       .name = "arc-uart",                             \
> +       .id = n,                                        \
> +       .num_resources = ARRAY_SIZE(arc_uart##n##_res), \
> +       .resource = arc_uart##n##_res,                  \
> +       .dev = {                                        \
> +               .platform_data = &arc_uart_info,        \
> +       },                                              \
> +}
> +
> +ARC_UART_DEV(0);
> +#if CONFIG_SERIAL_ARC_NR_PORTS > 1
> +ARC_UART_DEV(1);
> +#endif
> +
> +static struct platform_device *fpga_early_devs[] __initdata = {
> +#if defined(CONFIG_SERIAL_ARC_CONSOLE)
> +       &arc_uart0_dev,
> +#endif
> +};

statically defining platform devices like this is considered very
bad style, especially since it prevents you from doing proper
boot-time configuration. Please get the available devices from
the boot loader. Normally this is done using a flattened device
tree blob that gets passed, unless you can probe the hardware
directly.

	Arnd
