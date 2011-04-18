Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1DRITl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:19:41 -0400
Received: from linux-sh.org ([111.68.239.195]:47568 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab1DRITf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:19:35 -0400
Date: Mon, 18 Apr 2011 17:18:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 8/9] OMAP1 / PM: Use generic clock manipulation routines for runtime PM
Message-ID: <20110418081809.GA32457@linux-sh.org>
References: <201104130205.26988.rjw@sisk.pl> <201104170135.19388.rjw@sisk.pl> <201104170143.28980.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104170143.28980.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 01:43:28AM +0200, Rafael J. Wysocki wrote:
> @@ -75,24 +69,7 @@ static int __init omap1_pm_runtime_init(
>  	if (!cpu_class_is_omap1())
>  		return -ENODEV;
>  
> -	pm = platform_bus_get_pm_ops();
> -	if (!pm) {
> -		pr_err("%s: unable to get dev_pm_ops from platform_bus\n",
> -			__func__);
> -		return -ENODEV;
> -	}
> -
> -	omap_pm = kmemdup(pm, sizeof(struct dev_pm_ops), GFP_KERNEL);
> -	if (!omap_pm) {
> -		pr_err("%s: unable to alloc memory for new dev_pm_ops\n",
> -			__func__);
> -		return -ENOMEM;
> -	}
> -
> -	omap_pm->runtime_suspend = omap1_pm_runtime_suspend;
> -	omap_pm->runtime_resume = omap1_pm_runtime_resume;
> -
> -	platform_bus_set_pm_ops(omap_pm);
> +	pm_runtim_clock_add_notifier(&platform_bus_type, &platform_bus_notifier);
>  
Presumably you meant pm_runtime_clock_add_notifier() here. You seem to
have the same typo in a few other places too.
