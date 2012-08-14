Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2HNMtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:49:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2HNMtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:49:18 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Kelvin Cheung <keguang.zhang@gmail.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org, ralf@linux-mips.org,
        linux-mips@linux-mips.org, gregkh@suse.de, wuzhangjin@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 4/5] USB: Add EHCI bus glue for Loongson1x SoCs (UPDATED)
Date: Tue, 14 Aug 2012 14:49:04 +0200
Message-ID: <2068844.Lgd4iRJr0U@flexo>
Organization: OpenWrt
User-Agent: KMail/4.8.4 (Linux/3.2.0-24-generic; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1326868876-20271-1-git-send-email-keguang.zhang@gmail.com>
References: <1326868876-20271-1-git-send-email-keguang.zhang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kelvin,

On Wednesday 18 January 2012 14:41:16 Kelvin Cheung wrote:
> Use ehci_setup() in ehci_ls1x_reset().
> 
> The Loongson1x SoCs have a built-in EHCI controller.
> This patch adds the necessary glue code to make the generic EHCI
> driver usable for them.
> 
> Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
> ---

I do not see this driver doing anything fancy which would require an entirely 
new ehci implementation so consider using the generic ehci platform driver 
(drivers/usb/host/ehci-platforms.c) instead.

>  drivers/usb/Kconfig          |    1 +
>  drivers/usb/host/ehci-hcd.c  |    5 ++
>  drivers/usb/host/ehci-ls1x.c |  159 
++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 165 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/usb/host/ehci-ls1x.c
> 
> diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
> index 85d5a01..78ac78b 100644
> --- a/drivers/usb/Kconfig
> +++ b/drivers/usb/Kconfig
> @@ -68,6 +68,7 @@ config USB_ARCH_HAS_EHCI
>  	default y if ARCH_MSM
>  	default y if MICROBLAZE
>  	default y if SPARC_LEON
> +	default y if MACH_LOONGSON1

Do this in arch/mips/Kconfig instead.
--
Florian
