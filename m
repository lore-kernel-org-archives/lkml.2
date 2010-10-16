Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0JPI0I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 04:26:08 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:34630 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0JPI0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 04:26:06 -0400
Date: Sat, 16 Oct 2010 04:25:59 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
        linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot
 hang
In-reply-to: <20101005114047.GA29495@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.1010160416340.2238@localhost.localdomain>
References: <alpine.LFD.2.00.1009242122390.8641@localhost.localdomain>
 <20100927135735.GA856@srcf.ucam.org>
 <alpine.LFD.2.00.1009301810380.7033@localhost.localdomain>
 <20100930222946.GB23084@srcf.ucam.org>
 <alpine.LFD.2.00.1010050104450.23209@localhost.localdomain>
 <20101005114047.GA29495@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > we check (and clear) that bit only if the acpi tables
> > > > tell us to do so.
> > > 
> > > Do the tables tell us to do so on this platform?
> > 
> > In this configuration, yes, otherwise acpi_idle
> > would have failed in exactly the same way.
> 
> So why is intel_idle not paying attention to what the platform is 
> requesting?

ACPI's BM_STS mechanism is obsolete, and is fundmentally
incompatible with a tickless OS.  The status bit is a NO-OP
on most modern chip-sets under normal conditions.
However, even when not a NO-OP, it is supposed to
be just an indicator and clearing it should have
no functional effect on the hardware except to
re-arm the hardware that looks for BM_STS.

Clearing BM_STS on the NM10 chipset at boot-time to
make the system boot has nothing to do with
"what the platform is requesting".
It is a workaround for a platform bug that is randomly
masked by how the behaviour of the legacy ACPI OS.

intel_idle it knows nothing about ACPI, and it never will.

thanks,
Len Brown, Intel Open Source Technology Center


