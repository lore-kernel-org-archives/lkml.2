Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2C0On5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:43:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46691 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab2C0Onh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:43:37 -0400
Date: Mon, 26 Mar 2012 12:49:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <JBeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH 2/2] RFC: Xen pad logic
Message-ID: <20120326164910.GF10236@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923350AD0A6@SHSMSX101.ccr.corp.intel.com>
 <20120314002442.GC20363@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335105F35@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335105F35@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090201.4F71D20D.00B6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 07:29:09AM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> >> +static struct acpi_driver xen_acpi_pad_driver = {
> >> +	.name = "processor_aggregator",
> >> +	.class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
> >> +	.ids = xen_pad_device_ids,
> >> +	.ops = {
> >> +		.add = xen_acpi_pad_add,
> >> +		.remove = xen_acpi_pad_remove,
> >> +	},
> >> +};
> >> +
> >> +static int __init xen_acpi_pad_init(void)
> >> +{
> >> +	return acpi_bus_register_driver(&xen_acpi_pad_driver);
> > 
> > If the acpi_bus_register_driver function could work with multiple
> > acpi_drivers that define the same class (and have some priority) would
> > this be easier?
> 
> Not quite clear your point, could you elaborate more?

I was thinking it could do multiple registration of a driver servicing the
same PNPxxx.
