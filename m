Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2KGIwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:52:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:5018 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab2KGIwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:52:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,728,1344236400"; 
   d="scan'208";a="216217977"
Date: Wed, 7 Nov 2012 10:54:58 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>, grant.likely@secretlab.ca
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
Message-ID: <20121107085458.GV24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <4684026.MA6h34pt1X@vostro.rjw.lan>
 <CACRpkdbRWPYHBwLVTm-TDRVyp9Kmoaxw0uZg0schn7i0koDKJw@mail.gmail.com>
 <2396674.M1Yl70Z09T@vostro.rjw.lan>
 <CACRpkda6jNsKwowdJZ6d7kua5uBPH2tZT8Ka9vheEiPjvEJuUg@mail.gmail.com>
 <20121106093904.GM24532@intel.com>
 <CACRpkdaNqjHenMyPbEEFpE+5mvWqHsMNO3T3H=NM4X7TxU-sGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaNqjHenMyPbEEFpE+5mvWqHsMNO3T3H=NM4X7TxU-sGw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 11:15:21AM +0100, Linus Walleij wrote:
> On Tue, Nov 6, 2012 at 10:39 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Mon, Nov 05, 2012 at 03:40:14PM +0100, Linus Walleij wrote:
> >> > I forgot to mention that we want to hook up _existing_ drivers to those things,
> >> > and they already use the global GPIO numbers, don't they?
> >>
> >> Yes they do, usually this is either passed from the platform using platform
> >> data or handled by device tree lookups to individual drivers.
> >>
> >> So you will have to modify each such existing driver to do ACPI
> >> probe akin to the DT codepath and call acpi_get_gpio() on every pin they
> >> need going forward. But that is the plan I guess.
> >
> > Yes, that's the plan.
> >
> > Do you think it is OK to go with this implementation (acpi_get_gpio()) for
> > now? We will try to make sure that the gpio_get() (or whatever it will be
> > called that time) supports ACPI as well.
> 
> Yes I'll be OK with it but I don't dare to merge it unless Grant
> ACKs it.

Is that an Ack from you? ;-)

Since there is a dependency to linux-pm tree (we use the new
dev->acpi_handle member) I would like this series merged via that tree.

Grant, are you OK with this?
