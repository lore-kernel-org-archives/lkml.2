Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab2I2Nb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 09:31:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:5884 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab2I2Nb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 09:31:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,507,1344236400"; 
   d="scan'208";a="216158304"
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
Thread-Index: AQHNnUwsN9thNCVdUUiny25wHDluHZefRj6AgAILrJA=
Date: Sat, 29 Sep 2012 13:31:52 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926322C156@SHSMSX101.ccr.corp.intel.com>
References: <1348817910.10877.321.camel@rui.sh.intel.com>
 <20120928141347.GC15548@intel.com>
In-Reply-To: <20120928141347.GC15548@intel.com>
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
> Sent: Friday, September 28, 2012 10:14 PM
> To: Zhang, Rui
> Cc: LKML; linux-pm; linux-i2c; linux-acpi@vger.kernel.org; Len, Brown;
> Rafael J. Wysocki; Grant Likely; Dirk Brandewie
> Subject: Re: [RFC PATCH 1/6] Introduce acpi_match_device_id().
> Importance: High
> 
> On Fri, Sep 28, 2012 at 03:38:30PM +0800, Zhang Rui wrote:
> > >From 72df5d1f51fb27a4ba7f70a3b07df759d32b8288 Mon Sep 17 00:00:00
> > >2001
> > From: Zhang Rui <rui.zhang@intel.com>
> > Date: Thu, 27 Sep 2012 15:11:55 +0800
> > Subject: [RFC PATCH 1/6] Introduce acpi_match_device_id().
> >
> > This API is used to check if a device id string is compatible with an
> > ACPI device, either PNP id exported via _HID or compatible ids
> > exported via _CID control method.
> >
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >  drivers/acpi/scan.c     |   22 ++++++++++++++++++++++
> >  include/acpi/acpi_bus.h |    6 ++++++
> >  2 files changed, 28 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c index
> > d1ecca2..936a7c9 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -312,6 +312,28 @@ int acpi_match_device_ids(struct acpi_device
> > *device,  }  EXPORT_SYMBOL(acpi_match_device_ids);
> >
> > +int acpi_match_device_id(const struct device *dev, const char *id)
> 
> Would be good idea to implement this in terms of of_match_device() so
> that it returns pointer to the matched id. This way drivers can get the
> ->driver_data pretty easily if needed.
>
Good idea.
Will do that in v2.
 
> > +{
> > +	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
> 
> If the device is not bound to an ACPI handle this will return NULL. And
> I don't see you doing that in this series meaning that..
> 


You're right, I should set pdev->archdata.acpi_handle to the I2C controller in i2c_root.c.

Thanks,
rui
