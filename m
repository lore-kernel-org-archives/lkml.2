Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab2CNA3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:29:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32121 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab2CNA3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:29:53 -0400
Date: Tue, 13 Mar 2012 20:24:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <JBeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH 2/2] RFC: Xen pad logic
Message-ID: <20120314002442.GC20363@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923350AD0A6@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350AD0A6@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F5FE63C.0026,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static struct acpi_driver xen_acpi_pad_driver = {
> +	.name = "processor_aggregator",
> +	.class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
> +	.ids = xen_pad_device_ids,
> +	.ops = {
> +		.add = xen_acpi_pad_add,
> +		.remove = xen_acpi_pad_remove,
> +	},
> +};
> +
> +static int __init xen_acpi_pad_init(void)
> +{
> +	return acpi_bus_register_driver(&xen_acpi_pad_driver);

If the acpi_bus_register_driver function could work with multiple
acpi_drivers that define the same class (and have some priority) would
this be easier?
