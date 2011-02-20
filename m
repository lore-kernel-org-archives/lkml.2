Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab1BTVh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 16:37:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab1BTVh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 16:37:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly macros
Date: Sun, 20 Feb 2011 22:37:47 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, glikely@secretlab.ca,
        jamie@jamieiles.com
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com> <1298052881-14591-3-git-send-email-john.linn@xilinx.com> <42efee69-aca1-446b-a997-f0063e113877@VA3EHSMHS009.ehs.local>
In-Reply-To: <42efee69-aca1-446b-a997-f0063e113877@VA3EHSMHS009.ehs.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102202237.47327.arnd@arndb.de>
X-Provags-ID: V02:K0:xe93cJVO8pWmUWC6bFwRioFPiyLapJPo9CAJiER30yo
 0+aTeJYbDu10z9mWnNfK5sx3qCQa6yOSIqMXya9Lk1LdtwyWNy
 6o72I/uJ7Ht8GCQ92gZ8l8oOcR3JBngBeZFihi2XTaMngBFyat
 btZJhHIjui1ADTT+3bhefCxke6ZS6RA2zc46+EjKM4cAui5Vet
 rwDcVGXuiMo2Lc6FlX0AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 February 2011, John Linn wrote:
> +
> +/* IO address mapping macros, nothing special at this time but required */
> +
> +#ifdef __ASSEMBLER__
> +#define IOMEM(x)               (x)
> +#else
> +#define IOMEM(x)               ((void __force __iomem *)(x))
> +#endif
> +
> +#define __io(a)                        __typesafe_io(a)
> +#define __mem_pci(a)           (a)

Are you planning to support PCI or PCMCIA? If so, the __io definition will have to
change so it points to the PIO register window.

> diff --git a/arch/arm/mach-xilinx/include/mach/timex.h b/arch/arm/mach-xilinx/include/mach/timex.h
> new file mode 100644
> index 0000000..4ebc0a6
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/include/mach/timex.h
> +#ifndef __MACH_TIMEX_H__
> +#define __MACH_TIMEX_H__
> +
> +#define PERIPHERAL_CLOCK_RATE  2500000
> +
> +#define CLOCK_TICK_RATE        (PERIPHERAL_CLOCK_RATE / 32)
> +
> +#endif

I thought we were at the point where CLOCK_TICK_RATE is no longer used.
Did the patches not make it in yet?

The rest looks fine to me.

	Arnd
