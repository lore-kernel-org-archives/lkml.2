Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2BSThr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 14:37:47 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:21526 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2BSTgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 14:36:54 -0500
Date: Sun, 19 Feb 2012 13:24:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>, Jan Beulich <JBeulich@suse.com>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [PATCH 3/3] Xen pad logic and notification
Message-ID: <20120219182428.GB11882@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC829233509D87E@SHSMSX101.ccr.corp.intel.com>
 <20120217143727.GC29110@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923350A0869@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350A0869@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F414F4D.000A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
> > 
> > How does that work when the the driver is booted under baremetal?
> > Won't it kick out the native ACPI_PROCESSOR_AGGREGATOR_CLASS
> > (acpi_pad.c) ? 
> > 
> > What about if the other ACPI_PROCESSOR_AGGREGATOR_CLASS gets called
> > first? Won't this fail?
> > 
> > Or is the acpi_bus_register_driver smart enough to process more than
> > one ACPI bus device?
> 
> When driver booted under baremetal, xen_acpi_pad.c would be disabled and native acpi_pad.c logic would work.

Ah right. It is b/c it uses the pvops indirection mechanism.
