Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab0JWRcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:32:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46612 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab0JWRcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:32:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in get_property()
Date: Sat, 23 Oct 2010 19:31:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101016141321.GA11054@sucs.org> <201010230019.14100.rjw@sisk.pl> <20101023153637.GA8994@sucs.org>
In-Reply-To: <20101023153637.GA8994@sucs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010231931.24701.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 23, 2010, Sitsofe Wheeler wrote:
> On Sat, Oct 23, 2010 at 12:19:13AM +0200, Rafael J. Wysocki wrote:
> > 
> > OK, so can you test the patch below, please?
> 
> The latest patch seems to fix/workaround the problem. upower now reports
> 0 as the energy rate, there are no warnings in dmesg and battery hotplug
> works. Looks good and there's the option for a future upower to
> interpret the missing sysfs as meaning "unknown".
> 
> Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

Thanks for testing!

> > The function acpi_battery_get_property() is called by the
> > power supply framework's function power_supply_show_property()
> > implementing the sysfs interface for power supply devices as the
> > ACPI battery driver's ->get_property() callback.  Thus it is supposed
> > to return error code if the value of the given property is unknown.
> > Unfortunately, however, it returns 0 in those cases and puts a
> > wrong (negative) value into the intval field of the
> > union power_supply_propval object provided by
> > power_supply_show_property().  In consequence, wron negative
> 
> wron -> wrong?

Sure, thanks.

> > Fix this by making acpi_battery_get_property() return -ENODEV
> > for properties with unknown values (-ENODEV is returned, because
> > power_supply_uevent() returns with error for any other error code
> > returned by power_supply_show_property()).
> 
> OK that's sneaky and clever - technically power_supply_uevent should be
> more robust but presumably things are already prepared to handle -ENODEV

Yes, they are.  That's why I decided to use it. :-)

> so overloading the meaning leads to the smallest change.

That's correct.

I'll repost the patch shortly with fixed changelog and your tested-by.

Thanks,
Rafael
