Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2C0OoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:44:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18639 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2C0Ong (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:43:36 -0400
Date: Mon, 26 Mar 2012 12:48:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <jbeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] RFC: Prepare PAD for native and	xen
 platform
Message-ID: <20120326164835.GE10236@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923350AD088@SHSMSX101.ccr.corp.intel.com>
 <4F46530B020000780007F751@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923350AD9BB@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350B2013@SHSMSX101.ccr.corp.intel.com>
 <20120226173458.GB18098@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923350B9496@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350BAC09@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC8292335105EFA@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335105EFA@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F71D20D.0031,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Compare approaches:
> > 
> > 1. xen overwritten approach (patches V2, x86_init, osl approach)
> >     Pros:
> >         a little simpler code
> >     Cons:
> >         1). specific to xen, cannot extend to other virt platform;
> >         2). need to change natvie acpi_pad as modular;
> > 
> > 2. paravirt interface approach (original patches V1)
> >     Pros:
> >         1). standard hypervisor-agnostic interface (USENIX conference
> >         2006), can easily hook to Xen/lguest/... on demand; 2). arch
> >         independent; 3). no need to change native acpi_pad as
> >     non-modular; Cons:
> >         a little complicated code, and code patching is some
> > overkilled for this case (but no harm); 
> > 
> > (BTW, in the future we need add more and more pv ops, like pv_pm_ops,
> > pv_cpu_hotplug_ops, pv_mem_hotplug_ops, etc. So how about add a
> > pv_misc_ops template to handle them all? seems it's a common issue).  
> > 

I think (and you probabaly have a better idea) is that the maintainer of 
drivers/acpi/* is not very open to adding in code that only benefits Xen.

If it benefits other architectures (say ARM) then adding in hooks there
(in osl for example) makes sense - but I am not sure if ARM has a form
of _PUR code/calls it needs to do.

So with that in mind, neither of those options seems proper - as all of them
depend on changing something in drivers/acpi/*.

I've one or two suggestions of what could be done to still make this
work, but I need you to first see what happens if the native acpi_pad
runs under Xen with the latest upstream code (along with three patches
that are in a BZ I pointed you too). 
