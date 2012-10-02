Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab2JBGHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:07:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:36486 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab2JBGHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:07:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,521,1344236400"; 
   d="scan'208";a="151380839"
Date: Tue, 2 Oct 2012 09:10:05 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC PATCH 1/6] Introduce acpi_match_device_id().
Message-ID: <20121002061005.GN15548@intel.com>
References: <1348817910.10877.321.camel@rui.sh.intel.com>
 <20120928141347.GC15548@intel.com>
 <744357E9AAD1214791ACBA4B0B90926322C156@SHSMSX101.ccr.corp.intel.com>
 <20121001063753.GE15548@intel.com>
 <744357E9AAD1214791ACBA4B0B90926322D93C@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926322D93C@SHSMSX101.ccr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 01:56:17PM +0000, Zhang, Rui wrote:
> 
> 
> > -----Original Message-----
> > From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> > Sent: Monday, October 01, 2012 2:38 PM
> > To: Zhang, Rui
> > Cc: LKML; linux-pm; linux-i2c; linux-acpi@vger.kernel.org; Len, Brown;
> > Rafael J. Wysocki; Grant Likely; Dirk Brandewie
> > Subject: Re: [RFC PATCH 1/6] Introduce acpi_match_device_id().
> > Importance: High
> > 
> > On Sat, Sep 29, 2012 at 01:31:52PM +0000, Zhang, Rui wrote:
> > >
> > > > > +{
> > > > > +	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
> > > >
> > > > If the device is not bound to an ACPI handle this will return NULL.
> > > > And I don't see you doing that in this series meaning that..
> > > >
> > >
> > >
> > > You're right, I should set pdev->archdata.acpi_handle to the I2C
> > > controller in i2c_root.c.
> > 
> > There already is an API for that - check drivers/acpi/glue.c.
> 
> Do you mean acpi_bind?

No, I mean register_acpi_bus_type(). You can see an example of this looking
PCI, USB, .., drivers.
