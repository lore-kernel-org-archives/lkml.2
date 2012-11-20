Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab2KTHEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:04:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:51954 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab2KTHEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:04:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,284,1352102400"; 
   d="scan'208";a="170436040"
Date: Tue, 20 Nov 2012 09:07:56 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jean Delvare <khali@linux-fr.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/3 UPDATED] i2c / ACPI: add ACPI enumeration support
Message-ID: <20121120070756.GM17774@intel.com>
References: <1499062.QDd9DGofy9@vostro.rjw.lan>
 <20121116144256.55b49cae@endymion.delvare>
 <20121116141729.GS17774@intel.com>
 <20121116152332.GV17774@intel.com>
 <20121116174753.67d71043@endymion.delvare>
 <20121116172828.GY17774@intel.com>
 <CAErSpo6f4LtW0Sm8hs8bToyN8r8AhzrovJ_ybv62qDGP6+ABPA@mail.gmail.com>
 <20121117080354.GB17774@intel.com>
 <20121117095537.GC17774@intel.com>
 <CAErSpo46YMLg=AJgtx=bouWJKz0eMTm5GA3s3+=8Z8-_GLu-9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo46YMLg=AJgtx=bouWJKz0eMTm5GA3s3+=8Z8-_GLu-9g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 03:49:25PM -0700, Bjorn Helgaas wrote:
> I think the benefit here is that you can merely point
> .acpi_match_table at an acpi_device_id[] table, then use
> platform_get_resource() as a generic way to get resources, whether the
> platform device came from OF, ACPI, etc.  The alternative would be to
> add, e.g., a PNP driver with a .probe() method that uses
> pnp_get_resource().  That's not very much code, but it is more, even
> if the .probe() method just calls a device registration function
> that's shared across bus types.
> 
> That benefit seems like a great thing, and my question then is why
> wouldn't we just do it across the board and make platform devices for
> *all* ACPI devices without having the I2C and SPI special cases?

That wouldn't be any better than having a PNP or ACPI device. We must still
create the corresponding I2C or SPI device in order to have a driver that
can plug into I2C or SPI core.
