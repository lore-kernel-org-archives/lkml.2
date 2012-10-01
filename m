Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2JAGmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 02:42:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:32096 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab2JAGmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 02:42:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,514,1344236400"; 
   d="scan'208";a="228941533"
Date: Mon, 1 Oct 2012 09:44:33 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC PATCH 0/6] ACPI: ACPI 5.0 device enumeration proposal
Message-ID: <20121001064433.GF15548@intel.com>
References: <1348817863.10877.320.camel@rui.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348817863.10877.320.camel@rui.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 03:37:43PM +0800, Zhang Rui wrote:
> 
> the main idea is that, for Serial Buses like I2C and SPI, we enumerate
> the controller as a platform device, and then enumerate the slaves via
> i2c/spi_register_board_info. And then, when the controller is really
> probed and enabled in the platform driver, the SPI/I2C bus code will
> enumerate I2C/SPI slaves automatically.
> And for the other devices, we will enumerate all of them as platform
> devices, which is not covered in this patch set yet.

Can you show some example how we could use this new code for example with
an existing I2C/SPI slave driver? Let's say the device uses few GPIOs, one
for interrupt and other for triggering firmware download. In addition to
that it needs a special parameters that can be extracted running the "_DSM"
method of the device.

Normally the driver would get this stuff from the platform data or from
Device Tree but how it is done with these patches?
