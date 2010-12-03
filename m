Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab0LCL67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:58:59 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47077 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493Ab0LCL65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:58:57 -0500
Date: Fri, 3 Dec 2010 12:58:42 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Doug Thompson <norsk5@yahoo.com>,
        "Arvind R." <arvind@acarlab.com>
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101203115842.GB3169@aftab>
References: <20101201143329.GB18074@a1.tnic>
 <1291225614.8646.4.camel@Tobias-Karnat>
 <20101201193508.GA4916@liondog.tnic>
 <1291280613.10626.22.camel@Tobias-Karnat>
 <20101202152106.GA29301@a1.tnic>
 <1291306872.3898.7.camel@Tobias-Karnat>
 <20101202170610.GE27263@aftab>
 <1291313101.5563.13.camel@Tobias-Karnat>
 <20101202183724.GH27263@aftab>
 <1291329254.8869.66.camel@Tobias-Karnat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291329254.8869.66.camel@Tobias-Karnat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 05:34:14PM -0500, Tobias Karnat wrote:
> I thought as you wrote later, that this would be an option to use an
> interrupt instead of polling for edac in general.
>
> But as far as I understand this, it is used for PCI bus errors?

Yep, reportedly, memory parity errors can be reported through an NMI.
However, I don't know whether all chipset vendors still do that since
this is legacy and all.

> And should be replaced for detection of PCI SERR and/or PCIE AER,
> are these the same as PCI bus errors?

Yep, this all pertains to PCI/PCIe error reporting but don't
ask me about specifics. You might get some more info from
http://lwn.net/Articles/193468/ - it is not in the current kernel
sources though. Also, EDAC has a generic polling routine for PCI errors,
see <drivers/edac/edac_pci_sysfs.c:edac_pci_dev_parity_test()>

> > And yes, using some kind of an interrupt is much better than polling but
> > I don't know whether there's a single interrupt source for the error
> > types all edac drivers can decode and report. In the amd64_edac case,
> > we're piggybacking on MCE, for example. This was actually the initial
> > reason for 00740c58541b6087d78418cebca1fcb86dc6077d and dropping polling
> > from that driver.
> 
> From Intel Architectures Software Developer's Manual Part 3A:
> 
> "Starting with 45nm Intel 64 processor with CPUID signature
> DisplayFamily_DisplayModel encoding of 06H_1AH (...), the processor can
> report information on corrected machine-check errors and deliver a
> programmable interrupt for software to respond to MC errors, referred to
> as corrected machine-check error interrupt (CMCI)."
> 
> Seems to be unlikely for me on an Intel 975X Mainboard.

Hmm, I don't know, let's ask the driver author :)

Arvind?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
