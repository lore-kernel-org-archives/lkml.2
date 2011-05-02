Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1EBQkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 12:40:06 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60600 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750988Ab1EBQkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 12:40:02 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/URrhnvBHpdAGtY5bL/4vl
Date: Mon, 2 May 2011 19:39:54 +0300
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/8] arm/dt: probe for platforms via the device tree
Message-ID: <20110502163951.GC9243@atomide.com>
References: <20110429070135.12522.35745.stgit@ponder>
 <20110429071548.12522.56929.stgit@ponder>
 <20110502151542.GG2092@atomide.com>
 <BANLkTikue6jMUcQMv9GD4cZ=o5EEW7QDqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikue6jMUcQMv9GD4cZ=o5EEW7QDqQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@secretlab.ca> [110502 18:31]:
> On Mon, May 2, 2011 at 9:15 AM, Tony Lindgren <tony@atomide.com> wrote:
> > * Grant Likely <grant.likely@secretlab.ca> [110429 00:13]:
> >> +
> >> +/**
> >> + * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
> >> + * @dt_phys: physical address of dt blob
> >> + *
> >> + * If a dtb was passed to the kernel in r2, then use it to choose the
> >> + * correct machine_desc and to setup the system.
> >> + */
> >> +struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
> >> +{
> > ...
> >
> >> +
> >> +     /* Retrieve various information from the /chosen node */
> >> +     of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
> >
> > Just to make sure we're considering properly what this change means..
> >
> > Does this patch require using CONFIG_CMDLINE_FORCE for older bootloaders
> > with the device tree append patch?
> 
> With the current patch?  Yes, but there is a follow-on patch that was
> posted a while ago[1] that will copy ATAG data into the device tree in
> the bootloader.  I've not been pushing to include that change since it
> adds a lot of code to the wrapper and I'm not sure how deeply we want
> to support that use case.  Basically I want to have a better idea what
> the supported use cases are before pushing something like that.

OK. Maybe that could be made simpler if we only copy the cmdline?

The cmdline is something that bootloaders typically allow to configure,
while the other ATAGs are static and should be in the .dts file.
 
> Adding a default command line to the .dts file instead of using
> CONFIG_CMDLINE_FORCE also works.

But that requires carrying extra patches for something that should
be user configured.. So not so nice for distros.

Tony
 
> [1] http://lists.ozlabs.org/pipermail/devicetree-discuss/2011-March/004652.html
