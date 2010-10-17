Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab0JQKAR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:00:17 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:50410 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab0JQKAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:00:15 -0400
Date: Sun, 17 Oct 2010 10:59:40 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in
	get_property()
Message-ID: <20101017095940.GA4077@sucs.org>
References: <20101016141321.GA11054@sucs.org> <201010170105.33274.rjw@sisk.pl> <20101017051953.GA3430@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017051953.GA3430@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 03:19:53AM -0200, Henrique de Moraes Holschuh wrote:
> On Sun, 17 Oct 2010, Rafael J. Wysocki wrote:
> > In fact, the driver is supposed to return -ENODATA in that case, which will
> > result in the read from /sys/class/power_supply/BAT0/current_now
> > fail (I guess upower should be able to cope with that).
>
> ENODATA?  Shouldn't it be ENXIO?  There is no non-blocking data stream
> involved in a sysfs attribute.

Using ENODATA and ENXIO appears to solve the problem (upower reports a
rate of 0.0). However when plugging the battery in after previously only
being on AC power none of the /sys/class/power_supply/BAT0/uevent:*
files are created so upower never realises a battery has been plugged
in. A further issue with ENXIO is is the following repeatedly appears in
dmesg:

power_supply BAT0: driver failed to report `current_now' property

> Of course, the RIGHT thing would be to not expose in sysfs attributes
> that are unsupported by the firmware/hardware in the first place, but
> that's easier said than done.

My understanding is that this very hard to do because you can't tell if
the problem was transient (battery settling) or permanent (feature not
supported).

-- 
Sitsofe | http://sucs.org/~sits/
