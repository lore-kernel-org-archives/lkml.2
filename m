Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab1IISBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:01:05 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:46647 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125Ab1IISBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:01:03 -0400
From: Kevin Hilman <khilman@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: <linux-arm-kernel@lists.infradead.org>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, ccross@android.com
Subject: Re: [PATCH v2 0/5] CPU PM notifiers
Organization: Texas Instruments, Inc.
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
Date: Fri, 09 Sep 2011 11:00:58 -0700
In-Reply-To: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
	(Santosh Shilimkar's message of "Sat, 3 Sep 2011 20:09:10 +0530")
Message-ID: <87ty8ly4rp.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Santosh Shilimkar <santosh.shilimkar@ti.com> writes:

[...]

> This patch set tries to address concerns with platform pm code
> calling into the driver for every block in the Cortex A9s
> during idle, hotplug, and suspend.  The first patch adds cpu pm
> notifiers that can be called by platform code, the second uses
> the notifier to save and restore the GIC state, and the third
> saves the VFP state.
>
> The notifiers are used for two types of events, CPU PM events and
> CPU cluster PM events.  CPU PM events are used to save and restore
> per-cpu context when a single CPU is preparing to enter or has
> just exited a low power state.  For example, the VFP saves the
> last thread context, and the GIC saves banked CPU registers.
>
> CPU cluster events are used after all the CPUs in a power domain
> have been prepared for the low power state.  The GIC uses these
> events to save global register state.

Stepping back from my earlier objections, I think I had a fundamental
misunderstanding about what these notifiers should be used for.

The current assumptions/goals seem to be

1) used only for devices in the same power domain as the CPU (cluster)
2) use only for one specific power state of the CPU (cluster): off.

For awhile now, we've been discussing how to better coordinate CPU PM
transitions (CPUidle) with non-CPU PM transitions (runtime PM) for
devices that are tightly coupled to the CPU, but not necessarily in the
same powerdomain.

I was assuming (and hoping) that CPU PM notifiers could be used to do
that, but the more I think about it, I don't think we can achieve the
current CPU PM goals and the coordination with runtime PM with this
series.

I think it's more likely that we'll need to do some work with Rafael's
new PM domains to make that work correctly.

So, I'll retract my objections to this series, and feel free to add

Reviewed-by: Kevin Hilman <khilman@ti.com>

Kevin
