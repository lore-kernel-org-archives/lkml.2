Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2KFO50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 09:57:26 -0500
Received: from smtp.citrix.com ([66.165.176.89]:48546 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab2KFO5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 09:57:24 -0500
X-IronPort-AV: E=Sophos;i="4.80,722,1344211200"; 
   d="scan'208";a="43617205"
Date: Tue, 6 Nov 2012 14:56:40 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233537B147@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1211061455150.2689@kaball.uk.xensource.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com> <5089676602000078000A4928@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com> <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com> <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com> <20121026201409.GF2708@phenom.dumpdata.com> <DE8DF0795D48FD4CA783C40EC8292335377346@SHSMSX101.ccr.corp.intel.com>
 <20121102164937.GC27213@konrad-lan.dumpdata.com> <alpine.DEB.2.02.1211051512260.2689@kaball.uk.xensource.com> <DE8DF0795D48FD4CA783C40EC829233537B10C@SHSMSX101.ccr.corp.intel.com> <DE8DF0795D48FD4CA783C40EC829233537B147@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.80.2.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012, Liu, Jinsong wrote:
> Liu, Jinsong wrote:
> > Stefano Stabellini wrote:
> >>>> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> >>>> index 0e86370..a2af622 100644
> >>>> --- a/drivers/xen/Makefile
> >>>> +++ b/drivers/xen/Makefile
> >>>> @@ -29,6 +29,7 @@ obj-$(CONFIG_XEN_MCE_LOG)           += mcelog.o
> >>>>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)     += xen-pciback/
> >>>>  obj-$(CONFIG_XEN_PRIVCMD)            += xen-privcmd.o
> >>>>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)     += xen-acpi-processor.o
> >>>> +obj-$(CONFIG_XEN_DOM0)                       += xen_acpi_pad.o
> >>>>  xen-evtchn-y                         := evtchn.o
> >>>>  xen-gntdev-y                         := gntdev.o
> >>>>  xen-gntalloc-y                               := gntalloc.o
> >> 
> >> it should really depend on ACPI and maybe also X86, otherwise it is
> >> going to break the ARM build 
> >> 
> >> 
> > 
> > Hmm, XEN_DOM0 has already depended on ACPI and X86_LOCAL_APIC (which
> > depends on X86_64). 
> > 
> 
> Ah, you and Konrad are right. I ignore XEN_DOM0 varies under different arch.
> (But seems it not depends on X86 since it's logically an acpi stuff?).
 
If it is generic ACPI code, than it can depend only on ACPI.
If it is ACPI code that contains X86 specific info, than it needs to
depend on X86 too.
