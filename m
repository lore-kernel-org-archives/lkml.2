Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1DFDDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 23:03:22 -0400
Received: from imr4.ericy.com ([198.24.6.8]:42135 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab1DFDDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 23:03:20 -0400
Date: Tue, 5 Apr 2011 20:02:20 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Natarajan Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH] Make all it87 drivers SMP safe.
Message-ID: <20110406030220.GB22535@ericsson.com>
References: <1302038697-28985-1-git-send-email-natg@google.com>
 <20110405223814.GA21350@ericsson.com>
 <BANLkTimQDVYe53K-M173iQtmkHzKg6Djyg@mail.gmail.com>
 <20110406000528.GB21350@ericsson.com>
 <BANLkTi==zj3PoNuqf2=THaHzevvHHsuh=w@mail.gmail.com>
 <20110406004312.GA21882@ericsson.com>
 <BANLkTinSAOxNkjxMGewfPUc0-bjf9MesGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTinSAOxNkjxMGewfPUc0-bjf9MesGA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 10:50:47PM -0400, Natarajan Gurumoorthy wrote:
> Guenter,
>       Thank you for spotting the fact the everything goes south if you
> disable "watchdog". I am working on a solution. Looks like the ideal
> place to store it87_io_lock.c will be drivers/misc and the IT87_LOCK
> config will be placed before the MISC_DEVICES entry in
> drivers/misc/Kconfig file. This will be similar to the
> SENSORS_LIS3LV02D entry in that Kconfig file.
> 
Almost, only afaik that is only used inside the misc directory, or at least
has some other components there. I don't really know how to handle this
situation correctly, except you could of course write a mfd driver to handle
the generic parts.

>       Now going back to the partitioning do I send this change out as
> a multi patch set consisting of 4 parts something as below:
> 
> patch 0 has a description
> 
> patch 1 has only the lock and related files
>         drivers/misc/Kconfig
>         drivers/misc/Makefile
>         include/linux/it87_lock.h
>         drivers/misc/it87_lock.c
> 
> patch 2 has drivers/watchdog changes
>         drivers/watchdog/Kconfig
>         drivers/watchdog/it8712f_wdt.c
>         drivers/watchdog/it87_wdt.c
> 
> patch 3 has drives/hwmon changes
>         drivers/hwmon/Kconfig
>         drivers/hwmon/it87.c
> 
Something like that. I have some doubts about using drivers/misc,
but I guess you'll get feedback on that after you submit the patch set.

Thanks,
Guenter
