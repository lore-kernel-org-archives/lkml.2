Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab2E0KXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 06:23:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2E0KXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 06:23:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH RFC] serial/8250: Adjusting FIFO parameters for LPC32xx
Date: Sun, 27 May 2012 10:23:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
References: <1338048678-23991-1-git-send-email-stigge@antcom.de> <201205270232.58253.arnd@arndb.de> <4FC1EEA7.2060109@antcom.de>
In-Reply-To: <4FC1EEA7.2060109@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201205271023.16742.arnd@arndb.de>
X-Provags-ID: V02:K0:3/+zuYtVN6nTNVjTBhdKaWQIePtX7VP3VrHtw4b198p
 s0k0WmEcZnNSwPJ5G7mK/r/yXxtE4eCxDapglWIxpYp/w4uTwo
 KRHXJPekf93GmtJQE6/TTzMRrmgqd7kZYVPtgCp7Aah2LZqcxZ
 echjRYnkmyXTNwb8Ej09qqqnfe1piEIpgxCk2AAjl/D2UERktJ
 /Xa8SxkykjmbU1xEqQLzvQ97Ag/78uBQK6mw0pWXdxZyQHrTLP
 cFmvQkR0GCh0vVaJ7EdgY4htvTDzyoY3xYKsF97bsZaQ+tU6Kl
 omIcZ07r9yjHcuXxqEfgWKjpcSNX7wbwEToCYirvJHaV1BvdwK
 OZNFcyYZK9CTmfCsFiek=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 May 2012, Roland Stigge wrote:
> I did it via the following modification in of_serial.c:
> 
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -179,6 +179,7 @@ static struct of_device_id __devinitdata of_platform_serial_table[] = {
>         { .compatible = "ns16450",  .data = (void *)PORT_16450, },
>         { .compatible = "ns16550a", .data = (void *)PORT_16550A, },
>         { .compatible = "ns16550",  .data = (void *)PORT_16550, },
> +       { .compatible = "ns16654",  .data = (void *)PORT_16654, },
>         { .compatible = "ns16750",  .data = (void *)PORT_16750, },
>         { .compatible = "ns16850",  .data = (void *)PORT_16850, },
>         { .compatible = "nvidia,tegra20-uart", .data = (void *)PORT_TEGRA, },
> 
> Works for now, will need to test more thoroughly with LPC32xx (note that
> the manual explicitly mentions "downwards compatible with the INS16Cx50"
> and "Register locations conform to ‘550 industry standard" but nothing
> about an EFR register which 16654 is configured for in 8250.c).
> 
> The patch should be useful in of_serial anyway (even without the LPC32xx
> case).
> 
> Wondering if it should rather be .compatible = "st16654"?
> Will prepare a patch with adjustment of Documentation/.../of-serial.txt when
> we agree on sth.

I think st16654 would be better than ns16654 here, yes.

Actually some of the other entries are wrong, too. The ns8250 entry should
be i8250, and I guess the 16750 and 16850 were also not made by national.

	Arnd
