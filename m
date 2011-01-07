Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1AGWoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:44:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33670 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1AGWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:44:03 -0500
Date: Fri, 7 Jan 2011 22:43:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: vexpress: register platform PATA device.
Message-ID: <20110107224348.GZ31708@n2100.arm.linux.org.uk>
References: <1294435445-2020-1-git-send-email-nbowler@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294435445-2020-1-git-send-email-nbowler@elliptictech.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 04:24:05PM -0500, Nick Bowler wrote:
> The compactflash device on this platform is not usable simply because it
> is never registered with the kernel.  Fix that up.
> 
> Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
> ---
>  arch/arm/Kconfig             |    1 +
>  arch/arm/mach-vexpress/v2m.c |   25 +++++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index d56d21c..ee61039 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -264,6 +264,7 @@ config ARCH_VEXPRESS
>  	select HAVE_CLK
>  	select ICST
>  	select PLAT_VERSATILE
> +	select HAVE_PATA_PLATFORM

To avoid the Kconfig warning, this should be:

	select HAVE_PATA_PLATFORM if ATA

or it needs to be moved outside of the if ATA ... endif block in
drivers/ata/Kconfig.

Apart from that, I see nothing wrong.
