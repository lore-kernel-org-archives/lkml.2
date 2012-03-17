Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031384Ab2CQSvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 14:51:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60369 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2CQSve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 14:51:34 -0400
Message-ID: <1332010422.22775.76.camel@saladin.home.flameeyes.eu>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
From: Diego Elio =?ISO-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Date: Sat, 17 Mar 2012 19:53:42 +0100
In-Reply-To: <20120317123151.AAF9A3E0952@localhost>
References: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
	 <20120317123151.AAF9A3E0952@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno sab, 17/03/2012 alle 12.31 +0000, Grant Likely ha scritto:
> Really?  The config line above claims IT8761E support.  How similar are
> these devices?  Either this line needs to be more specifc, or the drivers
> need to be merged.

I'm not sure about IT8761E, and it seems it's only partially the case
from the code I read; it probably would be possible — Denis would you
mind taking a look?

It could possibly work to merge them. For what it's worth I've more or
less followed on the steps of the two watchdog timer drivers for IT87
series.

> use #define pr_fmt and pr_*() macros.  Better yet, use dev_{info,err,debug}()
> macros where possible.

Will do.

> Why "superio_" prefix here?  Are these functions that are cut-and-paste
> from another driver, or are they it87xx specific?  If they are it87xx specific
> then they should have the it87_ prefix.

They seem to be shared across a number of different Super I/O chips; in
particular though they come out of wdt_it87 (which interfaces in part
through the GPIO). As I said, and as Guenter already confirmed, it might
be the case to have an it87_sio driver for the Super I/O chip that
provides the basic interface for gpio, hwmon and wdt at the same time.

I'm just not sure if I can get through it alone, especially since
reading through the mfd drivers there seem to be those that simply
"earmark" the ports for other drivers, which can then be loaded, and
those that simply create everything in their own code, and I wouldn't
know which one of the two to use ...

Another reason to have a MFD driver would be to allow tweaking the few
more knobs that (at least IT8728F) expose, such as the ability to switch
a few pre-defined inputs and outputs to GPIO instead, and so on...

> No spinlock around the critical regions?  This is racy.

Okay I'll reintroduce that. I wonder though if it should be a ngpio/8
array of spinlocks or just one, but I guess it's fast enough it
shouldn't matter.

> If you're going to do a lookup table like this, then be explicit for
> the offsets:

Will do that.

-- 
Diego Elio Pettenò — Flameeyes
http://blog.flameeyes.eu/


