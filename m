Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0GANcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:32:19 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56845 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754027Ab0GANcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:32:17 -0400
Date: Thu, 1 Jul 2010 15:32:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>, Arve Hj??nnev??g <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PM: Make it possible to avoid wakeup events from being
 lost
Message-ID: <20100701133208.GA1285@ucw.cz>
References: <201006261514.13491.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006261514.13491.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> @@ -114,3 +114,17 @@ Description:
>  		if this file contains "1", which is the default.  It may be
>  		disabled by writing "0" to this file, in which case all devices
>  		will be suspended and resumed synchronously.
> +
> +What:		/sys/power/wakeup_count
> +Date:		July 2010
> +Contact:	Rafael J. Wysocki <rjw@sisk.pl>
> +Description:
> +		The /sys/power/wakeup_count file allows user space to avoid
> +		losing wakeup events when transitioning the system into a sleep
> +		state.  Reading from it returns the current number of registered
> +		wakeup events and it blocks if some wakeup events are being
> +		processed at the time the file is read from.  Writing to it
> +		will only succeed if the current number of wakeup events is
> +		equal to the written value and, if successful, will make the
> +		kernel abort a subsequent transition to a sleep state if any
> +		wakeup events are reported after the write has returned.

I assume that second suspend always succeeds?

I can't say I quite like the way two sysfs files interact with each
other, but it is certainly better then wakelocks...

Maybe we should create sys_suspend()?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
