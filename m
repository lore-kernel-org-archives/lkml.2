Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3AJJyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:54:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:5299 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab3AJJye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:54:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="272182731"
Date: Thu, 10 Jan 2013 11:58:03 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from
 platform data
Message-ID: <20130110095803.GJ13897@intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <50EC90C3.2090604@intel.com>
 <20130109122550.GA20956@opensource.wolfsonmicro.com>
 <4412354.TD27KzhhVJ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4412354.TD27KzhhVJ@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 11:07:26PM +0100, Rafael J. Wysocki wrote:
> We hardcode different kinds of information into the kernel anyway, but it
> would be good to be able to use some criteria to decide whether or not we need
> that information on the given system.
> 
> In this particular case, we'll only need the fixed clock rate for the SPI
> which is not present on other x86 systems to date.
> 
> Mika, do you have any idea what checks to apply to figure out whether or not
> the SPI clock will be necessary?

I've tried to figure out them but so far I have no ideas :-/

If we put that behind some config option, it 1) confuses users and 2)
distro makers will select it anyway, so I don't see this as an option.

> Perhaps we can add a check into acpi_create_platform_device()?  Something like
> "if the device ID is present in table X, then run function Y for the device"
> where Y will configure the clock if the SPI is matched?

That would work but then we must also make sure that if the device was
enumerated from PCI, it gets this clock via some other means.

The LPSS devices can be configured to either appear on PCI or ACPI and of
course ACPI has the advantage because then we can enumerate the slave
devices behind the bus as well. However, it might be possible that we need
to support PCI enumeration at some point.

Furthermore, the SPI controller has an existing PCI glue driver
(spi-pxa2xx-pci.c) that needs to pass this clock as well. This is for Intel
CE4100 platform and we must make sure that it still works after our change.
