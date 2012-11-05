Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab2KEOvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:51:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:40231 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724Ab2KEOu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:50:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,715,1344236400"; 
   d="scan'208";a="237393759"
Date: Mon, 5 Nov 2012 16:53:15 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121105145315.GI24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdaZqka7g2ECAyD_bKhnoULhCP6cTJwMyEsTuVxiUiHy+A@mail.gmail.com>
 <20121105150326.3bbf69df@endymion.delvare>
 <1925265.4Cx64DgKbB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1925265.4Cx64DgKbB@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 03:19:58PM +0100, Rafael J. Wysocki wrote:
> 
> In the ACPI namespace we have device nodes and serial interfaces below them.
> In the above case we see that a single device node supports two different
> interfaces and in that case we probably should create two different
> struct i2c_adapter objects for the same ACPI device node.
> 
> Mika, what do you think?

I agree.

Only problem I see is that then we have two I2C adapter devices with the
same ACPI ID (and hence the same i2c_client->name). I wonder what the I2C
core thinks about that.
