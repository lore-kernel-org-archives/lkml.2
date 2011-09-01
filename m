Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab1IAQZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:25:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49114 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab1IAQZC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:25:02 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Hilman, Kevin" <khilman@ti.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 1 Sep 2011 21:54:41 +0530
Subject: RE: [PATCH] ARM: mach-davinci: Select PHYLIB for ARCH_DAVINCI_DM644x
Thread-Topic: [PATCH] ARM: mach-davinci: Select PHYLIB for
 ARCH_DAVINCI_DM644x
Thread-Index: AcxfwHwXpdE+hqF5REe0dSwNOW2fgwJAPwFg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930257268D10@dbde02.ent.ti.com>
References: <1313903348.25059.3.camel@phoenix>
In-Reply-To: <1313903348.25059.3.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Sun, Aug 21, 2011 at 10:39:08, Axel Lin wrote:
> We call phy_register_fixup_for_uid in davinci_evm_init, thus we need 
> select PHYLIB to fix below build error: (with "make davinci_all_defconfig")

This shouldn't happen with davinci_all_defconfig as it
selects PHYLIB (this doesn't undermine the need for a fix).

> 
>   LD      .tmp_vmlinux1
> arch/arm/mach-davinci/built-in.o: In function `davinci_phy_fixup':
> pm.c:(.text+0x35b8): undefined reference to `mdiobus_read'
> pm.c:(.text+0x35d4): undefined reference to `mdiobus_write'
> arch/arm/mach-davinci/built-in.o: In function `davinci_evm_init':
> pm.c:(.init.text+0x237c): undefined reference to `phy_register_fixup_for_uid'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  arch/arm/mach-davinci/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
> index c0deaca..029ec46b 100644
> --- a/arch/arm/mach-davinci/Kconfig
> +++ b/arch/arm/mach-davinci/Kconfig
> @@ -18,6 +18,7 @@ config ARCH_DAVINCI_DM644x
>  	bool "DaVinci 644x based system"
>  	select AINTC
>  	select ARCH_DAVINCI_DMx
> +	select PHYLIB

Selecting PHYLIB for the SoC isn't right because
only the EVM is affected by this issue.

Also, instead of selecting PHYLIB, a better fix
would be to define the fixup function within
#ifdef PHYLIB and have an empty fixup registration
function in case PHYLIB is not defined (which
should happen only when EMAC driver is not configured
in which case a fixup is not required anyway).

Thanks,
Sekhar

