Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab1D2UzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:55:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:57872 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1D2UzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:55:14 -0400
Date: Fri, 29 Apr 2011 13:54:56 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] PM / Runtime: Support for generic I/O power
 domains
Message-ID: <20110429205456.GC16989@suse.de>
References: <201104290154.12966.rjw@sisk.pl>
 <201104290154.56145.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104290154.56145.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 01:54:55AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introcude common headers, helper functions and callbacks allowing
> platforms to use simple generic power domains for runtime power
> management.
> 
> Introduce struct generic_power_domain to be used for representing
> power domains that each contain a number of devices and may be
> master domains or subdomains with respect to other power domains.
> Among other things, this structure includes callbacks to be
> provided by platforms for performing specific tasks related to
> power management (i.e. ->stop_device() may disable a device's
> clocks, while ->start_device() may enable them, ->power_on() is
> supposed to remove power from the entire power domain
> and ->power_off() is supposed to restore it).
> 
> Introduce functions that can be used as power domain runtime PM
> callbacks, pm_genpd_runtime_suspend() and pm_genpd_runtime_resume(),
> as well as helper functions for the initialization of a power
> domain represented by a struct generic_power_domain object,
> adding a device to or removing a device from it and adding or
> removing subdomains.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/Makefile |    2 
>  drivers/base/power/domain.c |  416 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pm.h          |    3 
>  include/linux/pm_domain.h   |   82 ++++++++
>  4 files changed, 501 insertions(+), 2 deletions(-)

If this solves the power domain issue, and no one has any problems with
getting to work on their platforms, it looks great to me.

Very nice job:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
