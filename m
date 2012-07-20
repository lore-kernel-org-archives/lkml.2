Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2GTVDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:03:40 -0400
Received: from waste.org ([173.11.57.241]:55304 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2GTVDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:03:39 -0400
Message-ID: <1342818213.23136.584.camel@calx>
Subject: Re: [PATCH] dmi: Feed DMI table to /dev/random driver
From: Matt Mackall <mpm@selenic.com>
To: Tony Luck <tony.luck@intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net
Date: Fri, 20 Jul 2012 16:03:33 -0500
In-Reply-To: <0107910@agluck-desktop.sc.intel.com>
References: <0107910@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 13:15 -0700, Tony Luck wrote:
> Send the entire DMI (SMBIOS) table to the /dev/random driver to
> help seed its pools.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> 
> This looks a useful addition to your /dev/random series. There are
> lots of platform specific goodies in this table (BIOS version, system
> serial number and UUID, count and version number of processors, DIMM
> slot population and serial numbers, etc.)
> 
> On the system I tested the patch on the table is 9866 bytes. Is it
> OK to dump that much into add_device_randomness() in one shot?

Yes, that's fine. We should also consider doing something similar with
various bus enumerations (PCI, USB, SCSI) and hotplug, we might pick up
similar goodies. Also, we should feed in the OF device tree on platforms
that use it.

-- 
Mathematics is the supreme nostalgia of our time.


