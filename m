Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0IQAlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 20:41:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35560 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab0IQAlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 20:41:18 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arve =?iso-8859-1?Q?Hj=F8nnev?= =?iso-8859-1?Q?=E5g?= 
	<arve@android.com>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: PM / Wakeup: Introduce wakeup source objects and event statistics (v2)
Organization: Deep Root Systems, LLC
References: <Pine.LNX.4.44L0.1009101119060.1651-100000@iolanthe.rowland.org>
	<201009110029.31843.rjw@sisk.pl> <201009150031.36070.rjw@sisk.pl>
Date: Thu, 16 Sep 2010 17:41:14 -0700
In-Reply-To: <201009150031.36070.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 15 Sep 2010 00:31:35 +0200")
Message-ID: <87eict5hhx.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Wakeup: Introduce wakeup source objects and event statistics (v2)
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

Hi Rafael,

This looks like a really useful feature.  Was doing some experiments
with this on OMAP, and found a minor cut-and-paste bug in the
Documentation file:

[...]

> +What:		/sys/devices/.../power/wakeup_max_time_ms
> +Date:		September 2010
> +Contact:	Rafael J. Wysocki <rjw@sisk.pl>
> +Description:
> +		The /sys/devices/.../wakeup_max_time_ms attribute contains
> +		the maximum time of processing a single wakeup event associated
> +		with the device, in milliseconds.  This attribute is read-only.
> +		If the device is not enabled to wake up the system from sleep
> +		states, this attribute is empty.
> +
> +What:		/sys/devices/.../power/wakeup_max_time_ms
                                                      ^^^
s/max/last/ for this one.

> +Date:		September 2010
> +Contact:	Rafael J. Wysocki <rjw@sisk.pl>
> +Description:
> +		The /sys/devices/.../wakeup_last_time_ms attribute contains
> +		the value of the monotonic clock corresponding to the time of
> +		signaling the last wakeup event associated with the device, in
> +		milliseconds.  This attribute is read-only.  If the device is
> +		not enabled to wake up the system from sleep states, this
> +		attribute is empty.

Kevin
