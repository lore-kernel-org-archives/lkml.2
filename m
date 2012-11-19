Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2KSVCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:02:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:48626 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab2KSVCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:02:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,280,1352102400"; 
   d="scan'208";a="170281482"
Date: Mon, 19 Nov 2012 23:05:28 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI / platform: Initialize ACPI handles of platform
 devices in advance
Message-ID: <20121119210528.GJ17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
 <1855340.enMgVW1AIC@vostro.rjw.lan>
 <12675091.beenkZth4X@vostro.rjw.lan>
 <1610515.dOb8aMkzLk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610515.dOb8aMkzLk@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 09:44:21PM +0100, Rafael J. Wysocki wrote:
> So, we want to have acpi_handle (or acpi_node) in addition to of_node in struct
> device (to be used in the analogous way plus for the execution of AML methods),
> but we don't want all users of device.h to have to include ACPI headers
> where the acpi_handle data type is defined.  For this reason, we're using
> (void *) as its data type now, which let's say I'm not really happy with.
> 
> I've been thinking about that for quite a while, though, and I'm not really
> sure what to do about that.  Perhaps we could define something like
> 
> struct acpi_dev_node {
> #ifdef CONFIG_ACPI
> 	void *handle;
> #endif
> };
> 
> in device.h and use that as "struct acpi_dev_node acpi_node;" in struct device.
> Then, we could add the following macro
> 
> #ifdef CONFIG_ACPI
> #define ACPI_HANDLE(dev)	((dev)->acpi_node.handle)
> #else
> #define ACPI_HANDLE(dev)	(NULL)
> #endif
> 
> and redefine DEVICE_ACPI_HANDLE(dev) as ((acpi_handle)ACPI_HANDLE(dev)).
> 
> Then, the $subject patch would add "struct acpi_dev_node acpi_node;" to
> struct platform_device_info and use ACPI_HANDLE(dev) instead of accessing
> the struct device's field directly.

In addition to struct platform_device_info, we are also going to add
similar to struct i2c_board_info. There already is of_node pointer so I was
thinking to add acpi_handle like you did for platform_device. Type of that
pointer of course needs to be figured out :)
