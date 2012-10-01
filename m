Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab2JAN4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:56:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:14354 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab2JAN4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:56:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,517,1344236400"; 
   d="scan'208";a="199204497"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: RE: [RFC PATCH 1/6] Introduce acpi_match_device_id().
Thread-Topic: [RFC PATCH 1/6] Introduce acpi_match_device_id().
Thread-Index: AQHNnUwsN9thNCVdUUiny25wHDluHZefRj6AgAILrJCAAivygIAA/q1g
Date: Mon, 1 Oct 2012 13:56:17 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926322D93C@SHSMSX101.ccr.corp.intel.com>
References: <1348817910.10877.321.camel@rui.sh.intel.com>
 <20120928141347.GC15548@intel.com>
 <744357E9AAD1214791ACBA4B0B90926322C156@SHSMSX101.ccr.corp.intel.com>
 <20121001063753.GE15548@intel.com>
In-Reply-To: <20121001063753.GE15548@intel.com>
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



> -----Original Message-----
> From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> Sent: Monday, October 01, 2012 2:38 PM
> To: Zhang, Rui
> Cc: LKML; linux-pm; linux-i2c; linux-acpi@vger.kernel.org; Len, Brown;
> Rafael J. Wysocki; Grant Likely; Dirk Brandewie
> Subject: Re: [RFC PATCH 1/6] Introduce acpi_match_device_id().
> Importance: High
> 
> On Sat, Sep 29, 2012 at 01:31:52PM +0000, Zhang, Rui wrote:
> >
> > > > +{
> > > > +	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
> > >
> > > If the device is not bound to an ACPI handle this will return NULL.
> > > And I don't see you doing that in this series meaning that..
> > >
> >
> >
> > You're right, I should set pdev->archdata.acpi_handle to the I2C
> > controller in i2c_root.c.
> 
> There already is an API for that - check drivers/acpi/glue.c.

Do you mean acpi_bind?
acpi_bind_one will bind the physical device node to the ACPI device,
But for the i2c controller ACPI device, the physical node is the I2C
adapter in the I2C bus.
If we introduce I2C bus ACPI binding, which is what we're doing now,
the i2c_adapter->dev.archdata.acpi_handle will be set to the ACPI
i2c controller handle by acpi_bind_one.

Thanks,
rui
