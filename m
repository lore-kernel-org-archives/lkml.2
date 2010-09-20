Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab0ITTAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:00:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614Ab0ITTAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:00:53 -0400
Date: Mon, 20 Sep 2010 11:59:08 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] PM / Wakeup: Introduce wakeup source objects and
 event statistics (v3)
Message-ID: <20100920185908.GA29380@suse.de>
References: <201009201957.40995.rjw@sisk.pl>
 <201009201959.10070.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009201959.10070.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 07:59:09PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Wakeup: Introduce wakeup source objects and event statistics (v3)
> 
> Introduce struct wakeup_source for representing system wakeup sources
> within the kernel and for collecting statistics related to them.
> Make the recently introduced helper functions pm_wakeup_event(),
> pm_stay_awake() and pm_relax() use struct wakeup_source objects
> internally, so that wakeup statistics associated with wakeup devices
> can be collected and reported in a consistent way (the definition of
> pm_relax() is changed, which is harmless, because this function is
> not called directly by anyone yet).  Introduce new wakeup-related
> sysfs device attributes in /sys/devices/.../power for reporting the
> device wakeup statistics.
> 
> Change the global wakeup events counters event_count and
> events_in_progress into atomic variables, so that it is not necessary
> to acquire a global spinlock in pm_wakeup_event(), pm_stay_awake()
> and pm_relax(), which should allow us to avoid lock contention in
> these functions on SMP systems with many wakeup devices.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Nice job!
