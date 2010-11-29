Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab0K2TXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:23:34 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5060 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0K2TXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:23:33 -0500
Message-ID: <4CF3FDB4.4050108@caviumnetworks.com>
Date: Mon, 29 Nov 2010 11:23:32 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: mkl0301@gmail.com
CC: cbouatmailru@gmail.com, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/1] USB: cns3xxx: Add EHCI and OHCI bus glue for cns3xxx
 SOCs
References: <1290700680-20066-1-git-send-email-mkl0301@gmail.com>
In-Reply-To: <1290700680-20066-1-git-send-email-mkl0301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2010 19:24:34.0009 (UTC) FILETIME=[0DBAA490:01CB8FFB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2010 07:58 AM, mkl0301@gmail.com wrote:
> From: Mac Lin<mkl0301@gmail.com>
>
> The CNS3XXX SOC has include USB EHCI and OHCI compatible controllers. This
> patch adds the necessary glue logic to allow ehci-hcd and ohci-hcd drivers to
> work on CNS3XXX
>
> The EHCI and OHCI controllers share a common clock control and reset bit,
> therefore additional check for the timming of enabling and disabling is
> required. The USB bit of PLL Power Down Control is also shared by OTG, 24MHz
> UART clock, Crypto clock, PCIe reference clock, and Clock Scale Generator.
> Therefore we only ensure it is enabled, while not disabling it.
>
> Signed-off-by: Mac Lin<mkl0301@gmail.com>
> ---
>   drivers/usb/Kconfig             |    2 +
>   drivers/usb/host/Kconfig        |   15 ++++
>   drivers/usb/host/ehci-cns3xxx.c |  171 +++++++++++++++++++++++++++++++++++++++
>   drivers/usb/host/ehci-hcd.c     |    5 +
>   drivers/usb/host/ohci-cns3xxx.c |  165 +++++++++++++++++++++++++++++++++++++
>   drivers/usb/host/ohci-hcd.c     |    5 +
>   6 files changed, 363 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/usb/host/ehci-cns3xxx.c
>   create mode 100644 drivers/usb/host/ohci-cns3xxx.c
>
> diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
> index 67eb377..5a7c8f1 100644
> --- a/drivers/usb/Kconfig
> +++ b/drivers/usb/Kconfig
> @@ -41,6 +41,7 @@ config USB_ARCH_HAS_OHCI
>   	default y if MFD_TC6393XB
>   	default y if ARCH_W90X900
>   	default y if ARCH_DAVINCI_DA8XX
> +	default y if ARCH_CNS3XXX
>   	# PPC:
>   	default y if STB03xxx
>   	default y if PPC_MPC52xx
> @@ -66,6 +67,7 @@ config USB_ARCH_HAS_EHCI
>   	default y if ARCH_AT91SAM9G45
>   	default y if ARCH_MXC
>   	default y if ARCH_OMAP3
> +	default y if ARCH_CNS3XXX
>   	default PCI
>

Can these be moved to the archecture Kconfig as:

	select USB_ARCH_HAS_OHCI
	select USB_ARCH_HAS_EHCI

Well to answer my own question, yes they can.

Should they?  I think so.

David Daney
