Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0IOLcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:32:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:62947 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IOLcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:32:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,370,1280732400"; 
   d="scan'208";a="324814253"
Date: Wed, 15 Sep 2010 13:32:45 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Gary King <gking@nvidia.com>
Cc: linux-kernel@vger.kernel.org, mike@compulab.co.il
Subject: Re: [PATCH v3] mfd: tps6586x: add basic interrupt support
Message-ID: <20100915113244.GA17201@sortiz-mobl>
References: <1284428262-14158-1-git-send-email-gking@nvidia.com>
 <20100915105534.GA2597@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915105534.GA2597@sortiz-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 12:55:34PM +0200, Samuel Ortiz wrote:
> Hi Gary,
> 
> On Mon, Sep 13, 2010 at 06:37:42PM -0700, Gary King wrote:
> > Hi Samuel, Mike,
> > 
> > This patch incorporates Mike's feedback to my v2 patch to add interrupt
> > support to the tps6586x driver.
> > 
> > Changes since v2:
> >  * Remove stale comment in commit message
> > 
> > Changes since v1:
> >  * Move the interrupt enum ordering to match the ACK register values
> > 
> >  * Treat the INT_ACK registers as a single 32b unsigned int.
> > 
> >  * Name and define all the interrupts on the device
> > 
> >  * If reading the ACK registers in the interrupt thread fails, IRQ_NONE
> >    is returned, rather than disabling the IRQ handler. This fixes
> >    interrupts following suspend.
> > 
> >  * The cascaded IRQ is passed through the i2c_client's .irq field, rather
> >    than through platform data.
> Patch applied, many thanks.
...with this build fix:


diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 01c928b..385cc38 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -563,8 +563,8 @@ config MFD_JZ4740_ADC
 	  This driver is necessary for jz4740-battery and jz4740-hwmon driver.
 
 config MFD_TPS6586X
-	tristate "TPS6586x Power Management chips"
-	depends on I2C && GPIOLIB
+	bool "TPS6586x Power Management chips"
+	depends on I2C && GPIOLIB && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
 	  If you say yes here you get support for the TPS6586X series of

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
