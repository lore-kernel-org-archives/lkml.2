Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab2LRPrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:47:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25939 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2LRPro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:47:44 -0500
Date: Tue, 18 Dec 2012 10:47:37 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 1/2] Xen acpi memory hotplug driver
Message-ID: <20121218154737.GB13450@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923353942F9@SHSMSX101.ccr.corp.intel.com>
 <20121128192601.GA15871@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233539AC1D@SHSMSX101.ccr.corp.intel.com>
 <20121205174307.GC16072@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923353A2366@SHSMSX101.ccr.corp.intel.com>
 <20121207140528.GA3140@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923353A7C7B@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923353A9E57@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923353AD822@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923353AD822@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>> Not only inform firmware.
> >>>> Hotplug notify callback will invoke acpi_bus_add -> ... ->
> >>>> implicitly invoke drv->ops.add method to add the hotadded memory
> >>>> device.
> >>> 
> >>> Gotcha.
> >> 
> >> ? So it will lose the notification and no way to add the new memory
> >> device in the future. 
> >> 
> >> Xen memory hotplug logic consist of 2 parts:
> >> 1) driver logic (.add/.remove etc)
> >> 2) notification install/callback logic
> >> If you want to use 'xen_stub driver + .add/.remove ops', then
> >> notification install/callback logic would implement with xen_stub
> >> driver (means in build-in part, otherwise it would lose notification
> >> when the ops unload) --> but that would make xen_stub in big build-in
> >> size.
> > 
> > How about
> > * build-in part: xen_stub driver (stub .add to record what matched
> > cpu devices) + notification install/callback; 
> > * module part: .add/.remove ops;
> > w/ it, native driver has no chance to load and no hotplug event lose,
> > and approximately 1/3 code is build-in and 2/3 are module. 
> > 
> > I think it will work but I'm not quite sure, at least we can have a
> > try/test? 
> > 
> > Thanks,
> > Jinsong
> > 
> 
> Thoughts? If you think it's OK, I will update later.

Pls try. I am just thinking that the less we of code that has to be built-in - the
better.
> 
> Thanks,
> Jinsong
