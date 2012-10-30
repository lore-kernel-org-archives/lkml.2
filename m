Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2J3Nty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:49:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:65351 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2J3Ntw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:49:52 -0400
Date: Tue, 30 Oct 2012 09:37:22 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Message-ID: <20121030133720.GA27463@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335373918@SHSMSX101.ccr.corp.intel.com>
 <20121029123950.GK2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335374C86@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335374C86@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +config XEN_ACPI_PAD_STUB
> > +	bool
> > +	depends on XEN_DOM0 && X86_64 && ACPI
> > +	default n
> > +
> 
> This Kconfig is pointless, if CONFIG_XEN_ACPI_PAD_STUB = n, native pad would successfully registerred, and then mwait #UD (we would revert df88b2d96e36d9a9e325bfcd12eb45671cbbc937, right?). So xen stub logic should unconditionally built-in kernel.


Potentially. Keep in mind that there is no need to built this if the
kernel is not built with ACPI.
.. snip.
> > +subsys_initcall(xen_acpi_pad_stub_init);
> 
> I'm still confused. In this way there are xen-acpi-pad-stub.c and xen-acpi-pad.c, and you want to let xen-acpi-pad loaded as module, right? how can xen-acpi-pad logic work when it was insmoded?

Via the register/unregister calls that this provides? Or does ACPI bus
drivers get immediately called once the call acpi_bus_register_driver?

Or can one 'poke' the 'add' and 'remove' calls so that once the "true"
PAD driver is loaded it will restart the ops->add call?
