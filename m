Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab0JWPhS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:37:18 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:57507 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab0JWPhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:37:16 -0400
Date: Sat, 23 Oct 2010 16:36:37 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in
	get_property()
Message-ID: <20101023153637.GA8994@sucs.org>
References: <20101016141321.GA11054@sucs.org> <201010212157.47952.rjw@sisk.pl> <20101021204620.GB3318@sucs.org> <201010230019.14100.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010230019.14100.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 12:19:13AM +0200, Rafael J. Wysocki wrote:
> 
> OK, so can you test the patch below, please?

The latest patch seems to fix/workaround the problem. upower now reports
0 as the energy rate, there are no warnings in dmesg and battery hotplug
works. Looks good and there's the option for a future upower to
interpret the missing sysfs as meaning "unknown".

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

> The function acpi_battery_get_property() is called by the
> power supply framework's function power_supply_show_property()
> implementing the sysfs interface for power supply devices as the
> ACPI battery driver's ->get_property() callback.  Thus it is supposed
> to return error code if the value of the given property is unknown.
> Unfortunately, however, it returns 0 in those cases and puts a
> wrong (negative) value into the intval field of the
> union power_supply_propval object provided by
> power_supply_show_property().  In consequence, wron negative

wron -> wrong?

> Fix this by making acpi_battery_get_property() return -ENODEV
> for properties with unknown values (-ENODEV is returned, because
> power_supply_uevent() returns with error for any other error code
> returned by power_supply_show_property()).

OK that's sneaky and clever - technically power_supply_uevent should be
more robust but presumably things are already prepared to handle -ENODEV
so overloading the meaning leads to the smallest change.

-- 
Sitsofe | http://sucs.org/~sits/
