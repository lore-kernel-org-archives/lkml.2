Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab2GFFui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 01:50:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:60910 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab2GFFug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 01:50:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119414190"
Date: Fri, 6 Jul 2012 08:52:34 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Lan Tianyu <tianyu.lan@intel.com>, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, chatty@enac.fr, jj_ding@emc.com.tw
Subject: Re: Fwd: Hid over I2C and ACPI interaction
Message-ID: <20120706055234.GC2237@intel.com>
References: <CAN+gG=GnMX8Gu6w9za2QrjoVrmORncFgq-+hhmHvxtOPEB=nDw@mail.gmail.com>
 <4FF52C70.9010601@intel.com>
 <1341471717.1682.125.camel@rui.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341471717.1682.125.camel@rui.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 03:01:57PM +0800, Zhang Rui wrote:
> +Note that although these are ACPI devices, we prefer to use PnP drivers
> for them,
> +this is because:
> +1. all the non-ACPI-predefined Devices are exported as PnP devices as
> well
> +2. PnP bus is a well designed bus. Probing via PnP layer saves a lot of
> work
> +   for the device driver, e.g. getting & parsing ACPI resources.

(Nice BKM, thanks for sharing)

I have few questions about using PnP drivers instead of pure ACPI drivers.

ACPI 5.0 defined some new resources, for example "Fixed DMA descriptor"
that has information about the request line + channel for the device to
use. Hovewer, PnP drivers pass resources as 'struct resource', which
basically only has start and end - how do you represent all this new stuff
using 'struct resource'?

Or should we use acpi_walk_resources() where 'struct resource' is not
suitable?
