Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab0JQNKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 09:10:21 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45947 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873Ab0JQNKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 09:10:19 -0400
X-Sasl-enc: qVgFTJxuJ+cdeUocq5eoMyV+Gs2W3D46CGkqqmhDczhh 1287321018
Date: Sun, 17 Oct 2010 11:10:16 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in
 get_property()
Message-ID: <20101017131016.GB13015@khazad-dum.debian.net>
References: <20101016141321.GA11054@sucs.org>
 <201010170105.33274.rjw@sisk.pl>
 <20101017051953.GA3430@khazad-dum.debian.net>
 <20101017095940.GA4077@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017095940.GA4077@sucs.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Oct 2010, Sitsofe Wheeler wrote:
> On Sun, Oct 17, 2010 at 03:19:53AM -0200, Henrique de Moraes Holschuh wrote:
> > On Sun, 17 Oct 2010, Rafael J. Wysocki wrote:
> > > In fact, the driver is supposed to return -ENODATA in that case, which will
> > > result in the read from /sys/class/power_supply/BAT0/current_now
> > > fail (I guess upower should be able to cope with that).
> >
> > ENODATA?  Shouldn't it be ENXIO?  There is no non-blocking data stream
> > involved in a sysfs attribute.
> 
> Using ENODATA and ENXIO appears to solve the problem (upower reports a
> rate of 0.0). However when plugging the battery in after previously only
> being on AC power none of the /sys/class/power_supply/BAT0/uevent:*
> files are created so upower never realises a battery has been plugged
> in. A further issue with ENXIO is is the following repeatedly appears in
> dmesg:

You might have broken firmware that does not issue a notify when a battery
is plugged.  But it has been a long time, I don't recall if the battery
driver handles hotplugging without the help of the dock/bay driver (it
should, AFAIK).

> power_supply BAT0: driver failed to report `current_now' property

And it keeps silent if it gets ENODATA?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
