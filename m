Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab0JQOvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:51:03 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:36907 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab0JQOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:51:01 -0400
Date: Sun, 17 Oct 2010 15:50:25 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in
	get_property()
Message-ID: <20101017145025.GA32599@sucs.org>
References: <20101016141321.GA11054@sucs.org> <201010170105.33274.rjw@sisk.pl> <20101017051953.GA3430@khazad-dum.debian.net> <20101017095940.GA4077@sucs.org> <20101017131016.GB13015@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017131016.GB13015@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 11:10:16AM -0200, Henrique de Moraes Holschuh wrote:
> On Sun, 17 Oct 2010, Sitsofe Wheeler wrote:
> > 
> > Using ENODATA and ENXIO appears to solve the problem (upower reports a
> > rate of 0.0). However when plugging the battery in after previously only
> > being on AC power none of the /sys/class/power_supply/BAT0/uevent:*
> > files are created so upower never realises a battery has been plugged
> 
> You might have broken firmware that does not issue a notify when a battery
> is plugged.  But it has been a long time, I don't recall if the battery
> driver handles hotplugging without the help of the dock/bay driver (it
> should, AFAIK).

Battery hotplug works fine without these patches. I should have said -
the uevent devices are there with a vanilla kernel no matter how many
times the battery is plugged in or unplugged (that's how I knew they
were missing with the patches added :) I am guessing some part of the
kernel/udev cannot handle being told ENODATA or ENXIO and bails out
before those nodes would be made.

> > in. A further issue with ENXIO is is the following repeatedly appears in
> > dmesg:
> > power_supply BAT0: driver failed to report `current_now' property
> 
> And it keeps silent if it gets ENODATA?

Yes.

-- 
Sitsofe | http://sucs.org/~sits/
