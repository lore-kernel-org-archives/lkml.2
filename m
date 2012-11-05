Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab2KESGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:06:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:57949 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab2KESGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:06:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,715,1344236400"; 
   d="scan'208";a="237487837"
Date: Mon, 5 Nov 2012 20:08:47 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jean Delvare <khali@linux-fr.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121105180847.GK24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdaZqka7g2ECAyD_bKhnoULhCP6cTJwMyEsTuVxiUiHy+A@mail.gmail.com>
 <20121105150326.3bbf69df@endymion.delvare>
 <1925265.4Cx64DgKbB@vostro.rjw.lan>
 <20121105145315.GI24532@intel.com>
 <20121105161920.44e8e1cb@endymion.delvare>
 <20121105171248.GJ24532@intel.com>
 <CAErSpo6h1uUG=Be8TmMeFcRcmTw2GWxChXUWOE0iS7oPNALNCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6h1uUG=Be8TmMeFcRcmTw2GWxChXUWOE0iS7oPNALNCQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 10:43:17AM -0700, Bjorn Helgaas wrote:
> > It should already be unique in case of ACPI. We use ACPI _HID and _UID to
> > achieve that.
> 
> Using only _HID and _UID to guarantee uniqueness means you're relying
> on a property of the BIOS, so you're vulnerable to BIOS bugs.
> 
> If there's an ACPI Device for I2C adapters, why wouldn't you just use
> its device name as set in acpi_device_register() (basically a _HID +
> instance number)?

That's a good point - we could change to use that instead (the platform
code in linux-pm tree uses _HID + _UID but I guess it is pretty trivial to
change).
