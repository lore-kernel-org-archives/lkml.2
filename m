Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab2JZGS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:18:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:36711 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab2JZGS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:18:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,652,1344236400"; 
   d="scan'208";a="209548559"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <JBeulich@suse.com>
CC: xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNsrxDTi91BiFLfUibRvXA4zlK85fLG3Tw
Date: Fri, 26 Oct 2012 06:18:23 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
In-Reply-To: <5089676602000078000A4928@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks! updated accordingly, w/ 2 comments left as below:

> +static const struct acpi_device_id pad_device_ids[] = {
> +	{"ACPI000C", 0},
> +	{"", 0},
> +};
> +
> +static struct acpi_driver xen_acpi_pad_driver = {
> +	.name = "processor_aggregator",
> +	.class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
> +	.ids = pad_device_ids,
> +	.ops = {
> +		.add = xen_acpi_pad_add,

.remove?

[Jinsong] .remove method not used by any logic now (any possible point use it?), so we remove it from our former patch.

> +	},
> +};
> +
> +static int __init xen_acpi_pad_init(void)
> +{
> +	/* Only DOM0 is responsible for Xen acpi pad */
> +	if (xen_initial_domain())
> +		return acpi_bus_register_driver(&xen_acpi_pad_driver);
> +
> +	return -ENODEV;
> +}
> +subsys_initcall(xen_acpi_pad_init);
> +
> +#endif

Overall I'd recommend taking a look at the cleaned up driver in
our kernels.

[Jinsong] What's your point here?

Thanks,
Jinsong
