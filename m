Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2KFQ4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 11:56:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47645 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2KFQ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 11:56:02 -0500
Date: Tue, 6 Nov 2012 11:43:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Message-ID: <20121106164303.GO9966@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335377346@SHSMSX101.ccr.corp.intel.com>
 <20121102164937.GC27213@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1211051512260.2689@kaball.uk.xensource.com>
 <DE8DF0795D48FD4CA783C40EC829233537B10C@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537B147@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1211061455150.2689@kaball.uk.xensource.com>
 <DE8DF0795D48FD4CA783C40EC829233537B479@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233537B479@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 04:23:57PM +0000, Liu, Jinsong wrote:
> Stefano Stabellini wrote:
> > On Tue, 6 Nov 2012, Liu, Jinsong wrote:
> >> Liu, Jinsong wrote:
> >>> Stefano Stabellini wrote:
> >>>>>> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> >>>>>> index 0e86370..a2af622 100644
> >>>>>> --- a/drivers/xen/Makefile
> >>>>>> +++ b/drivers/xen/Makefile
> >>>>>> @@ -29,6 +29,7 @@ obj-$(CONFIG_XEN_MCE_LOG)           += mcelog.o
> >>>>>>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)     += xen-pciback/
> >>>>>>  obj-$(CONFIG_XEN_PRIVCMD)            += xen-privcmd.o
> >>>>>>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)     += xen-acpi-processor.o
> >>>>>> +obj-$(CONFIG_XEN_DOM0)                       += xen_acpi_pad.o
> >>>>>>  xen-evtchn-y                         := evtchn.o
> >>>>>>  xen-gntdev-y                         := gntdev.o
> >>>>>>  xen-gntalloc-y                               := gntalloc.o
> >>>> 
> >>>> it should really depend on ACPI and maybe also X86, otherwise it
> >>>> is going to break the ARM build 
> >>>> 
> >>>> 
> >>> 
> >>> Hmm, XEN_DOM0 has already depended on ACPI and X86_LOCAL_APIC
> >>> (which depends on X86_64). 
> >>> 
> >> 
> >> Ah, you and Konrad are right. I ignore XEN_DOM0 varies under
> >> different arch. (But seems it not depends on X86 since it's
> >> logically an acpi stuff?). 
> > 
> > If it is generic ACPI code, than it can depend only on ACPI.
> > If it is ACPI code that contains X86 specific info, than it needs to
> > depend on X86 too.
> 
> No x86 specific so let's depend on ACPI.

Huh? This feature is x86 specific isn't it? I mean it is in the ACPI spec, but
only x86 does it right?
