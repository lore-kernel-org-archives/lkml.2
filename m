Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2KRPwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 10:52:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:63848 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2KRPwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 10:52:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,275,1352102400"; 
   d="scan'208";a="243985891"
Date: Sun, 18 Nov 2012 17:55:39 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/3 UPDATED] i2c / ACPI: add ACPI enumeration support
Message-ID: <20121118155539.GE17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAErSpo6f4LtW0Sm8hs8bToyN8r8AhzrovJ_ybv62qDGP6+ABPA@mail.gmail.com>
 <20121117080354.GB17774@intel.com>
 <3790210.BPELRzTIaN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3790210.BPELRzTIaN@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 12:24:45PM +0100, Rafael J. Wysocki wrote:
> Well, maybe there is one.  Perhaps we can make acpi_platform_notify() 
> call acpi_bind_one() upfront and only if that fails, do the whole
> type->find_device() dance?  Of course, acpi_bind_one() would need to
> be modified slightly too, like in the patch below.
> 
> If we did that, acpi_i2c_add_device() would only need to assign acpi_handle
> as appropriate before calling i2c_new_device() (and analogously for SPI).
> 
> What do you think? 

This is certainly better than the thing we use currently. It makes adding
I2C and SPI support much shorter and simpler. If others don't object I
would suggest that we switch to use this method.
