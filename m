Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1EKRTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:19:18 -0400
Received: from tex.lwn.net ([70.33.254.29]:43197 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab1EKRRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:17:34 -0400
Date: Wed, 11 May 2011 11:17:32 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/5] PM: Support for system-wide power transitions in
 generic power domains
Message-ID: <20110511111732.2f75713a@bike.lwn.net>
In-Reply-To: <201105082324.19674.rjw@sisk.pl>
References: <201104290154.12966.rjw@sisk.pl>
	<201105082320.57185.rjw@sisk.pl>
	<201105082324.19674.rjw@sisk.pl>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rafael,

One small question that came to mind as I was looking at this patch:

> +/**
> + * pm_genpd_powered_down - Check if power has been removed from a power domain.
> + * @genpd: Power domain to check.
> + */
> +static bool pm_genpd_powered_down(struct generic_power_domain *genpd)
> +{
> +	bool ret;
> +
> +	mutex_lock(&genpd->lock);
> +	ret = genpd->power_is_off;
> +	mutex_unlock(&genpd->lock);
> +
> +	return ret;

I'm not quite sure why this function exists?  The lock doesn't really
change anything, since the power state can change before or after this
check regardless.  If you need the power state to be stable, it seems like
the lock needs to be taken further up the stack; otherwise simply checking
genpd->power_is_off directly would seem to be sufficient. Am I missing
something?

Thanks,

jon
