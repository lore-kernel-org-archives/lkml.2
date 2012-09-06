Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab2IFOLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:11:54 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:50110 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755148Ab2IFOLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:11:52 -0400
Message-ID: <5048AF1F.8010607@ti.com>
Date: Thu, 06 Sep 2012 19:41:43 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Kevin Hilman <khilman@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit <b-cousson@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
References: <20120825214459.7333a376@notabene.brown> <CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com> <20120827085312.75957354@notabene.brown> <CAMQu2gwH0O+NHV7H2aF375qmv0=TKb6RweOLohTHtB4UhQ-1gQ@mail.gmail.com> <CAMQu2gw2b8HHDPuSRuHXVYn3sJ5BYi_PuOT=snpa3zD5ert=QQ@mail.gmail.com> <20120906130510.32b0b877@notabene.brown> <CAMQu2gxGNJ+NW_rcRiXNE=OMTq8Hb81_1hDZnNen6mjc2cf6BQ@mail.gmail.com> <20120906170245.10e97bdd@notabene.brown>
In-Reply-To: <20120906170245.10e97bdd@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 September 2012 12:32 PM, NeilBrown wrote:
> From: NeilBrown <neilb@suse.de>
> Subject: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
>
> Current kernel will wake from suspend on an event on any active
> GPIO even if enable_irq_wake() wasn't called.
>
> There are two reasons that the hardware wake-enable bit should be set:
>
> 1/ while non-suspended the CPU might go into a deep sleep (off_mode)
>   in which the wake-enable bit is needed for an interrupt to be
>   recognised.
> 2/ while suspended the GPIO interrupt should wake from suspend if and
>    only if irq_wake as been enabled.
>
> The code currently doesn't keep these two reasons separate so they get
> confused and sometimes the wakeup flags is set incorrectly.
>
> This patch reverts:
>  commit 9c4ed9e6c01e7a8bd9079da8267e1f03cb4761fc
>     gpio/omap: remove suspend/resume callbacks
> and
>  commit 0aa2727399c0b78225021413022c164cb99fbc5e
>     gpio/omap: remove suspend_wakeup field from struct gpio_bank
>
> and makes some minor changes so that we have separate flags for "GPIO
> should wake from deep idle" and "GPIO should wake from suspend".
>
> With this patch, the GPIO from my touch screen doesn't wake my device
> any more, which is what I want.
Just gave it a try fixes a similar issue on my omap4 board as well.
>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Cousson Benoit <b-cousson@ti.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Govindraj.R <govindraj.raja@ti.com>
>
> Signed-off-by: NeilBrown <neilb@suse.de>

