Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab1KVUnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:43:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45394 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab1KVUnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:43:14 -0500
Date: Tue, 22 Nov 2011 20:42:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: debug: Add CLSP711X_UART1 config choice
Message-ID: <20111122204238.GE9581@n2100.arm.linux.org.uk>
References: <20110916114140.GA31334@e102144-lin.cambridge.arm.com> <1316455300-5752-1-git-send-email-sboyd@codeaurora.org> <20110919212502.GB23613@e102144-lin.cambridge.arm.com> <4E77BE34.6070702@codeaurora.org> <20110919224151.GB28237@n2100.arm.linux.org.uk> <4E77C84E.9040202@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E77C84E.9040202@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 03:55:10PM -0700, Stephen Boyd wrote:
> Ah ok. How about this instead?

Better...

> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 9661c51..31896f4 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -93,14 +93,19 @@ choice
>                   It does include a timeout to ensure that the system does not
>                   totally freeze when there is nothing connected to read.
>  
> +       config DEBUG_FOOTBRIDGE_COM1
> +               bool "Kernel low-level debugging messages via footbridge 8250 at PCI COM1"

I don't think PC-isms help here - especially when these aren't labelled
using this terminology on devices.  Netwinder called it just a simple
"Serial" on the rear panel.

		bool "Kernel low-level debugging messages via 8250 serial port at 0x3f8"

> +               depends on FOOTBRIDGE
> +               help
> +                 Say Y here if you want the debug print routines to direct
> +                 their output to the 8250 at PCI COM1.

Same kind of fixup here.  Other than that, it seems fine.
