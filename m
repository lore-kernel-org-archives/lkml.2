Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab2DZUAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:00:05 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39661 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759130Ab2DZUAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:00:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Date: Thu, 26 Apr 2012 22:04:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Aaron Lu <aaron.lu@amd.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Andiry Xu <andiry.xu@amd.com>,
        Alex He <alex.he@amd.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com> <201204242315.00419.rjw@sisk.pl> <CAC=cRTPqSPLHvT+BXH7K3ff0u=pFCVAG6rLNSjntpj+ghgdM+Q@mail.gmail.com>
In-Reply-To: <CAC=cRTPqSPLHvT+BXH7K3ff0u=pFCVAG6rLNSjntpj+ghgdM+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204262204.41794.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 26, 2012, huang ying wrote:
> On Wed, Apr 25, 2012 at 5:15 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, April 24, 2012, Aaron Lu wrote:
> >> On Tue, Apr 24, 2012 at 09:15:37PM +0800, Lin Ming wrote:
> >> > >> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> >> > >> > index 7417267..734d946 100644
> >> > >> > --- a/drivers/acpi/scan.c
> >> > >> > +++ b/drivers/acpi/scan.c
> >> > >> > @@ -908,6 +908,10 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
> >> > >> >     device->power.states[ACPI_STATE_D3].flags.valid = 1;
> >> > >> >     device->power.states[ACPI_STATE_D3].power = 0;
> >> > >> >
> >> > >> > +   /* Also set D3cold's explicit flag when _PS3 exists */
> >> > >> > +   if (device->power.states[ACPI_STATE_D3_HOT].flags.explicit_set)
> >> > >> > +           device->power.states[ACPI_STATE_D3].flags.explicit_set = 1;
> >> > >>
> >> > >> We should use ACPI_STATE_D3_COLD instead of ACPI_STATE_D3 to make thing
> >> > >> clear.
> >> > >>
> >> > > Thanks for your suggestion.
> >> > >
> >> > > Well, considering all those ACPI_STATE_D3 used in tree, I don't think I
> >> > > should use ACPI_STATE_D3_COLD here, especially the two lines above are
> >> > > still using ACPI_STATE_D3.
> >> > >
> >> > > But if that is desired, we should probably change all the existing
> >> > > ACPI_STATE_D3 macros to ACPI_STATE_D3_COLD to make things clear.
> >> > >
> >> > > Or we all use ACPI_STATE_D3, since it is defined as 4 and means D3 cold,
> >> > > and people will learn this, won't they?
> >> > >
> >> > > What do you think?
> >> >
> >> > OK.
> >> >
> >> > But we may do more cleanup later.
> >> >
> >>
> >> Sure :-)
> >> I think the first thing to do is to agree on which macro should be used,
> >> ACPI_STATE_D3 or ACPI_STATE_D3_COLD. And then replace the other one
> >> altogether.
> >
> > I'd prefer to use ACPI_STATE_D3 wherever it makes sense, because that's
> > also well defined in older versions of ACPI (think pre-ACPI-4.0 BIOSes).
> 
> Because the relationship between ACPI_STATE_D3 and ACPI_STATE_D3_COLD
> is confusing, I suggest to add some comments whenever will refer to D3
> or D3_COLD.

Oh well.

This is how it works: D3 _is_ D3_COLD except when D3_HOT is supported
(ie. _PR3 is present) in which cases saying just "D3" may be ambiguous (quite
obviously).  I think that's clear enough.

Thanks,
Rafael
