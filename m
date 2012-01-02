Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2ABJF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 04:05:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33079 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2ABJFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 04:05:00 -0500
Date: Mon, 2 Jan 2012 02:04:54 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Benoit Cousson <b-cousson@ti.com>
Cc: rob.herring@calxeda.com, tony@atomide.com, linux-omap@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        sameo@linux.intel.com, ben-linux@fluff.org,
        Balaji T K <balajitk@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH v4 03/12] mfd: twl-core: Add initial DT support for
 twl4030/twl6030
Message-ID: <20120102090454.GO18381@ponder.secretlab.ca>
References: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
 <1324565806-31142-4-git-send-email-b-cousson@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324565806-31142-4-git-send-email-b-cousson@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 03:56:37PM +0100, Benoit Cousson wrote:
> Add initial device-tree support for twl familly chips.
> The current version is missing the regulator entries due
> to the lack of DT regulator bindings for the moment.
> Only the simple sub-modules that do not depend on
> platform_data information can be initialized properly.
> 
> Add irqdomain support.
> 
> Add documentation for the Texas Instruments TWL Integrated Chip.
> 
> Signed-off-by: Benoit Cousson <b-cousson@ti.com>
> Cc: Balaji T K <balajitk@ti.com>
> Cc: Graeme Gregory <gg@slimlogic.co.uk>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index f1391c2..f0de088 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -200,6 +200,7 @@ config MENELAUS
>  config TWL4030_CORE
>  	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
>  	depends on I2C=y && GENERIC_HARDIRQS
> +	select IRQ_DOMAIN

As discussed on linux-next, this breaks powerpc.  Drivers cannot select
IRQ_DOMAIN, it can only be selected by architectures.  Drivers must depend
on it instead.

