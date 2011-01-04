Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab1ADL3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 06:29:24 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:59518 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750803Ab1ADL3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 06:29:22 -0500
Date: Tue, 4 Jan 2011 12:29:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: jean.pihet@newoldbits.com
Cc: mingo@elte.hu, trenn@suse.de, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-perf-users@vger.kernel.org, Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 1/3] perf: add calls to suspend trace point
Message-ID: <20110104112919.GB9879@atrey.karlin.mff.cuni.cz>
References: <1294136263-24020-1-git-send-email-j-pihet@ti.com> <1294138109-24679-1-git-send-email-j-pihet@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294138109-24679-1-git-send-email-j-pihet@ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Uses the machine_suspend trace point, called from the
> generic kernel suspend_enter function.
> 
> Signed-off-by: Jean Pihet <j-pihet@ti.com>
> CC: Thomas Renninger <trenn@suse.de>
> ---
>  kernel/power/suspend.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index ecf7705..0650596 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -22,6 +22,7 @@
>  #include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <linux/suspend.h>
> +#include <trace/events/power.h>
>  
>  #include "power.h"
>  
> @@ -164,7 +165,9 @@ static int suspend_enter(suspend_state_t state)
>  	error = sysdev_suspend(PMSG_SUSPEND);
>  	if (!error) {
>  		if (!suspend_test(TEST_CORE) && pm_check_wakeup_events()) {
> +			trace_machine_suspend(state);
>  			error = suspend_ops->enter(state);
> +			trace_machine_suspend(PWR_EVENT_EXIT);
>  			events_check_enabled = false;
>  		}
>  		sysdev_resume();

Ok... why this place? I mean, perhaps suspend time should include
device suspend?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
