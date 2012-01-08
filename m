Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab2AHXc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:32:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:21434 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab2AHXc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:32:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104876649"
Date: Mon, 9 Jan 2012 00:38:20 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, rob.herring@calxeda.com,
        tony@atomide.com, linux-omap@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, Balaji T K <balajitk@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH v4 03/12] mfd: twl-core: Add initial DT support for
 twl4030/twl6030
Message-ID: <20120108233820.GH13679@sortiz-mobl>
References: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
 <1324565806-31142-4-git-send-email-b-cousson@ti.com>
 <20120102090454.GO18381@ponder.secretlab.ca>
 <4F030C2D.3000808@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F030C2D.3000808@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Tue, Jan 03, 2012 at 03:09:49PM +0100, Cousson, Benoit wrote:
> On 1/2/2012 10:04 AM, Grant Likely wrote:
> > On Thu, Dec 22, 2011 at 03:56:37PM +0100, Benoit Cousson wrote:
> >> Add initial device-tree support for twl familly chips.
> >> The current version is missing the regulator entries due
> >> to the lack of DT regulator bindings for the moment.
> >> Only the simple sub-modules that do not depend on
> >> platform_data information can be initialized properly.
> >>
> >> Add irqdomain support.
> >>
> >> Add documentation for the Texas Instruments TWL Integrated Chip.
> >>
> >> Signed-off-by: Benoit Cousson<b-cousson@ti.com>
> >> Cc: Balaji T K<balajitk@ti.com>
> >> Cc: Graeme Gregory<gg@slimlogic.co.uk>
> >> Cc: Samuel Ortiz<sameo@linux.intel.com>
> >> ---
> >> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> >> index f1391c2..f0de088 100644
> >> --- a/drivers/mfd/Kconfig
> >> +++ b/drivers/mfd/Kconfig
> >> @@ -200,6 +200,7 @@ config MENELAUS
> >>   config TWL4030_CORE
> >>   	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
> >>   	depends on I2C=y&&  GENERIC_HARDIRQS
> >> +	select IRQ_DOMAIN
> > 
> > As discussed on linux-next, this breaks powerpc.  Drivers cannot select
> > IRQ_DOMAIN, it can only be selected by architectures.  Drivers must depend
> > on it instead.
> 
> OK, good to know. The previous version was already breaking non-ARM platform because the IRQ_DOMAIN was not defined, hence this update.
> I was able to check that this patch was fixing at least x86... but did not have any way to check the PPC build.
> 
> To be honest, I did not fully understand that this flag was there because some arch does not support IRQ domain yet and thus it should be selected at arch level.
> 
> Samuel,
> Here is the updated version, and hopefully the last one, including Grant's fix.
> 
Thanks, I applied it now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
