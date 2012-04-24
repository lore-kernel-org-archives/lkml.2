Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2DXOZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:25:17 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:60002 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab2DXOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:25:15 -0400
Date: Tue, 24 Apr 2012 22:24:57 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Message-ID: <20120424142457.GA5292@fedora>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
 <201204231343.03382.rjw@sisk.pl>
 <20120423151327.GA4019@fedora>
 <201204232150.57812.rjw@sisk.pl>
 <20120424020708.GA10397@localhost.amd.com>
 <1335234576.15942.19.camel@minggr>
 <20120424031011.GA27099@ladygaga>
 <CAF1ivSbOhUbE6wreRQ5E3jV5N_haHn1y9q48CU_OZFeCRTed+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF1ivSbOhUbE6wreRQ5E3jV5N_haHn1y9q48CU_OZFeCRTed+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 09:15:37PM +0800, Lin Ming wrote:
> >> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> >> > index 7417267..734d946 100644
> >> > --- a/drivers/acpi/scan.c
> >> > +++ b/drivers/acpi/scan.c
> >> > @@ -908,6 +908,10 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
> >> >     device->power.states[ACPI_STATE_D3].flags.valid = 1;
> >> >     device->power.states[ACPI_STATE_D3].power = 0;
> >> >
> >> > +   /* Also set D3cold's explicit flag when _PS3 exists */
> >> > +   if (device->power.states[ACPI_STATE_D3_HOT].flags.explicit_set)
> >> > +           device->power.states[ACPI_STATE_D3].flags.explicit_set = 1;
> >>
> >> We should use ACPI_STATE_D3_COLD instead of ACPI_STATE_D3 to make thing
> >> clear.
> >>
> > Thanks for your suggestion.
> >
> > Well, considering all those ACPI_STATE_D3 used in tree, I don't think I
> > should use ACPI_STATE_D3_COLD here, especially the two lines above are
> > still using ACPI_STATE_D3.
> >
> > But if that is desired, we should probably change all the existing
> > ACPI_STATE_D3 macros to ACPI_STATE_D3_COLD to make things clear.
> >
> > Or we all use ACPI_STATE_D3, since it is defined as 4 and means D3 cold,
> > and people will learn this, won't they?
> >
> > What do you think?
> 
> OK.
> 
> But we may do more cleanup later.
> 

Sure :-)
I think the first thing to do is to agree on which macro should be used,
ACPI_STATE_D3 or ACPI_STATE_D3_COLD. And then replace the other one
altogether.

Thanks,
Aaron
