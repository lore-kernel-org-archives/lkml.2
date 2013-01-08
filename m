Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3AHMir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 07:38:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:23645 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab3AHMiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 07:38:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="274230603"
Date: Tue, 8 Jan 2013 14:41:53 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from
 platform data
Message-ID: <20130108124153.GJ13897@intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <1357555480-24022-6-git-send-email-mika.westerberg@linux.intel.com>
 <20130108110228.GM4544@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108110228.GM4544@opensource.wolfsonmicro.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 11:02:28AM +0000, Mark Brown wrote:
> On Mon, Jan 07, 2013 at 12:44:34PM +0200, Mika Westerberg wrote:
> > If the architecture doesn't support clk framework (like x86) we need a way to
> > pass the SSP clock rate to the driver. This patch adds a field in the platform
> > data 'fixed_clk_rate' that allows passing the rate.
> 
> No, the way to do this is to fix x86 to enable the clock API there.  The
> x86 maintainers couldn't be bothered when I submitted a patch and
> getting anyone to take a patch to make it available by default appears
> to be unreasonably hard but perhaps if someone from Intel tries the x86
> maintainers might take a patch...

Do you mean enabling CONFIG_COMMON_CLK on x86?

> We shouldn't be adding special case code to every driver that might need
> a clock that gets used on an Intel system.

I agree and it is cleaner to have the same API for all arches. However, I'm
not sure how do we create the fixed clocks then? There is nothing in ACPI
namespace (or in the ACPI 5.0 spec) that allows you to describe clocks and
their relationships.

So then we end up either:

	1. Creating a custom board file for Lynxpoint which creates the
	   clocks. This is something I think x86 maintainers don't want to
	   see.

	2. Creating the clock in the driver itself in its ACPI enumeration
	   implementation. This might work but it litters the drivers with
	   clock details.

Or is there something I'm missing?
