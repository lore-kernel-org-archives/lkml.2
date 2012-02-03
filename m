Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab2BCRu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:50:27 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:32911 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757191Ab2BCRuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:50:23 -0500
From: Kevin Hilman <khilman@ti.com>
To: balbi@ti.com
Cc: "Cousson\, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Charulatha V <charu@ti.com>
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
Organization: Texas Instruments, Inc.
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
	<1328203851-20435-2-git-send-email-tarun.kanti@ti.com>
	<20120202184106.GC29215@legolas.emea.dhcp.ti.com>
	<20120202191630.GT15343@ponder.secretlab.ca>
	<20120202194545.GA29351@legolas.emea.dhcp.ti.com>
	<4F2AF68D.1000505@ti.com>
	<20120202214907.GA22888@legolas.emea.dhcp.ti.com>
	<20120202215350.GB22888@legolas.emea.dhcp.ti.com>
	<4F2B078B.1040709@ti.com>
	<20120202220744.GA23092@legolas.emea.dhcp.ti.com>
Date: Fri, 03 Feb 2012 09:50:19 -0800
In-Reply-To: <20120202220744.GA23092@legolas.emea.dhcp.ti.com> (Felipe Balbi's
	message of "Fri, 3 Feb 2012 00:07:45 +0200")
Message-ID: <87liojajs4.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <balbi@ti.com> writes:

[...]

>> >This question remains. Why do we need those funtions ?
>> 
>> These functions are called from the CPUIdle path so outside the scope
>> of the GPIO driver. These are part of a bunch of nasty PM hacks we
>> are doing in the CPU idle loop. We are in the process of getting rid
>> of most of them, but it looks like some are still needed.
>
> Too bad. I can see that the gpio pm implementation seems a bit
> "peculiar". I mean, pm does reference counting and yet the driver has
> checks to prevent multiple gets and puts on a single bank (meaning that
> pm counter will be either 0 or 1 at any point in time).
>
> To me it looks like those functions are there in order to forcefully put
> PER power domain in OFF because drivers are always holding a reference
> to their gpios (drivers generally gpio_request() on probe() and
> gpio_free() on remove()).
>
> Looks like the entire pm implementation on OMAP gpio driver has always
> considered only the fact that gpios can be requested and freed, but
> never that we want the system to go to OFF even while gpios are
> requested, because we have I/O PAD wakeups. At some point that has to be
> sorted out because that HACK is quite ugly :-)
>
> I'll see if I find some time to go over the interactions between
> gpio-omap.c and pm24x.c and pm34xx.c any of these days, but I can't
> promise anything ;-)

If you look at the state of these prepare/resume hacks at the end of
this series, you'll see that they are significantly cleaner and do
nothing but call the runtime PM hooks.

We have explored several ways to get rid of them completely in the idle
path but have not yet come up with a clean way, but this series gets us
a long ways towards that goal.

Kevin



