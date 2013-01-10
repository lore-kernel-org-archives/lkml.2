Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3AJNEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:04:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:57750 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab3AJNEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:04:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,444,1355126400"; 
   d="scan'208";a="242276918"
Date: Thu, 10 Jan 2013 15:07:40 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        eric.y.miao@gmail.com, linux@arm.linux.org.uk,
        haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from
 platform data
Message-ID: <20130110130740.GP13897@intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130110095803.GJ13897@intel.com>
 <20130110123837.GO13897@intel.com>
 <2921304.SsX3sQo2BU@vostro.rjw.lan>
 <20130110125159.GQ20956@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110125159.GQ20956@opensource.wolfsonmicro.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 12:51:59PM +0000, Mark Brown wrote:
> On Thu, Jan 10, 2013 at 01:54:41PM +0100, Rafael J. Wysocki wrote:
> > On Thursday, January 10, 2013 02:38:37 PM Mika Westerberg wrote:
> 
> > > 	3. We make the acpi_create_platform_device() match on, lets say
> > > 	   "INT33C" (a partial match), and in such case it assumes that we are
> > >            running on Lynxpoint. It will then create platform device for 'clk-lpt'.
> 
> > > 	4. Now the clk-lpt driver creates the clocks.
> 
> > > 	5. The SPI driver gets the clock it wants.
> 
> > That sounds reasonable to me.  Mark, what do you think?
> 
> Sounds sensible, yes - about what I'd expect.  Is it possible to match
> on CPUID or similar information (given that this is all in the SoC)
> instead of ACPI, that might be more robust I guess?

I can look into that but I'm not sure whether there are any other way to
detect are we running on Lynxpoint or not, except the device IDs (and even
that is not 100% guaranteed because of ACPI _CIDs).
