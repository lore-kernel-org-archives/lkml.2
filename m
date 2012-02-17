Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab2BQT3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:29:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60868 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab2BQT3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:29:20 -0500
Date: Fri, 17 Feb 2012 20:29:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, "Len Brown (Intel)" <len.brown@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [Resend 2x] thermal: Prevent polling from happening during
 system suspend
Message-ID: <20120217192914.GH2707@elf.ucw.cz>
References: <201111061421.38580.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111061421.38580.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2011-11-06 14:21:38, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The thermal driver should use a freezable workqueue to schedule
> polling to prevent thermal_zone_device_update() from being run
> during system suspend, when the devices it relies on may be inactive.
> Make it use the system freezable workqueue for this purpose.

Umm. hibernation can take long time and (with latest compression
patches) can be CPU intensive.

Is it good idea to disable thermal management?

Should we kick fans to full speed before starting hibernation?
								Pavel

> @@ -678,10 +678,10 @@ static void thermal_zone_device_set_poll
>  		return;
>  
>  	if (delay > 1000)
> -		schedule_delayed_work(&(tz->poll_queue),
> +		queue_delayed_work(system_freezable_wq, &(tz->poll_queue),
>  				      round_jiffies(msecs_to_jiffies(delay)));
>  	else
> -		schedule_delayed_work(&(tz->poll_queue),
> +		queue_delayed_work(system_freezable_wq, &(tz->poll_queue),
>  				      msecs_to_jiffies(delay));
>  }

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
