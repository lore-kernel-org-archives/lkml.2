Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0I1RTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:19:15 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:51097 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab0I1RTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:19:14 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195Zv/KQMcSWCmFTxWGQbr1
Date: Tue, 28 Sep 2010 10:19:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] LogicPD minimal board support for LV_SOM and
 Torpedo
Message-ID: <20100928171908.GE3117@atomide.com>
References: <1285603550-6382-1-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285603550-6382-1-git-send-email-tim.nordell@logicpd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tim Nordell <tim.nordell@logicpd.com> [100927 08:57]:
> This was tested (and based) against 2.6.36-rc5
> 
> Difference from patch v3 1/4:
>  - Merged DEBUG_LL support patch (patch v3 5/5) into first patch
>  - Added "select OMAP_PACKAGE_CBB" into Kconfig for both boards
> 
> Tim Nordell (4):
>   Adding LogicPD OMAP3 board support
>   ARM: OMAP3LOGIC: Adding SDMMC support
>   ARM: OMAP3: Add generic smsc911x support when connected to GPMC
>   ARM: OMAP3LOGIC: Added SMSC Ethernet board support
> 
>  arch/arm/mach-omap2/Kconfig                     |   20 ++
>  arch/arm/mach-omap2/Makefile                    |    7 +
>  arch/arm/mach-omap2/board-omap3logic.c          |  244 +++++++++++++++++++++++
>  arch/arm/mach-omap2/gpmc-smsc911x.c             |  113 +++++++++++
>  arch/arm/plat-omap/include/plat/gpmc-smsc911x.h |   35 ++++
>  arch/arm/plat-omap/include/plat/uncompress.h    |    2 +
>  6 files changed, 421 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-omap3logic.c
>  create mode 100644 arch/arm/mach-omap2/gpmc-smsc911x.c
>  create mode 100644 arch/arm/plat-omap/include/plat/gpmc-smsc911x.h

Thanks, queuing all of them for the upcoming merge window.
I've updated the MMC related patch with the following to
keep it compiling with the MMC related platform init changes.

Regards,

Tony

--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -26,6 +26,7 @@
 #include <linux/regulator/machine.h>
 
 #include <linux/i2c/twl.h>
+#include <linux/mmc/host.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -112,7 +113,7 @@ static struct omap2_hsmmc_info __initdata board_mmc_info[] = {
 	{
 		.name		= "external",
 		.mmc		= 1,
-		.wires		= 4,
+		.caps		= MMC_CAP_4_BIT_DATA,
 		.gpio_cd	= -EINVAL,
 		.gpio_wp	= -EINVAL,
 	},
