Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab2E3WSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 18:18:46 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:48585 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833Ab2E3WSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 18:18:45 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Colin Cross <ccross@android.com>, Magnus Damm <magnus.damm@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [Update 3x][PATCH 2/2] PM / Domains: Add preliminary support for cpuidle
Organization: Texas Instruments, Inc.
References: <201205092340.26561.rjw@sisk.pl> <201205241817.43541.rjw@sisk.pl>
	<87zk8xp1v4.fsf@ti.com> <201205282350.40152.rjw@sisk.pl>
Date: Wed, 30 May 2012 15:18:41 -0700
In-Reply-To: <201205282350.40152.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Mon, 28 May 2012 23:50:39 +0200")
Message-ID: <878vg95n3y.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Friday, May 25, 2012, Kevin Hilman wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > On Thursday, May 24, 2012, Kevin Hilman wrote:
>> >> Hi Rafael,
>> >> 
>> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> >> 
>> >> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> >> >
>> >> > On some systems there are CPU cores located in the same power
>> >> > domains as I/O devices.  Then, power can only be removed from the
>> >> > domain if all I/O devices in it are not in use and the CPU core
>> >> > is idle.  Add preliminary support for that to the generic PM domains
>> >> > framework.
>> >> >
>> >> > First, the platform is expected to provide a cpuidle driver with one
>> >> > extra state designated for use with the generic PM domains code.
>> >> > This state should be initially disabled and its exit_latency value
>> >> > should be set to whatever time is needed to bring up the CPU core
>> >> > itself after restoring power to it, not including the domain's
>> >> > power on latency.  Its .enter() callback should point to a procedure
>> >> > that will remove power from the domain containing the CPU core at
>> >> > the end of the CPU power transition.
>> >> >
>> >> > The remaining characteristics of the extra cpuidle state, referred to
>> >> > as the "domain" cpuidle state below, (e.g. power usage, target
>> >> > residency) should be populated in accordance with the properties of
>> >> > the hardware.
>> >> >
>> >> > Next, the platform should execute genpd_attach_cpuidle() on the PM
>> >> > domain containing the CPU core.  That will cause the generic PM
>> >> > domains framework to treat that domain in a special way such that:
>> >> >
>> >> >  * When all devices in the domain have been suspended and it is about
>> >> >    to be turned off, the states of the devices will be saved, but
>> >> >    power will not be removed from the domain.  Instead, the "domain"
>> >> >    cpuidle state will be enabled so that power can be removed from
>> >> >    the domain when the CPU core is idle and the state has been chosen
>> >> >    as the target by the cpuidle governor.
>> >> >
>> >> >  * When the first I/O device in the domain is resumed and
>> >> >    __pm_genpd_poweron(() is called for the first time after
>> >> >    power has been removed from the domain, the "domain" cpuidle
>> >> >    state will be disabled to avoid subsequent surprise power removals
>> >> >    via cpuidle.
>> >> 
>> >> This looks like a good approach.  I like that it keeps a pretty clean
>> >> separation between CPUidle and PM domains.
>> >> 
>> >> My only comment would be that the recalc of the exit_latency should be
>> >> described a bit more.  Specifically, I'm not sure why it's adjused at
>> >> every genpd poweron.  At first I thought it was just supposed to be
>> >> adjusted upon attach, then adjusted back on detatch, but with the recalc
>> >> also in every poweron, I'm a little confused.  Care to clarify?
>> >
>> > The problem is that the PM domains code measures the time it takes to
>> > power off a domain and updates its power on latency parameter if the
>> > measured time is greater.  This is done for PM QoS to operate on realistic
>> > numbers (most of the time at least).
>> 
>> OK, I see.  Maybe clarifying that in the changelog would help make that
>> clearer.
>
> Sure.  I hope the updated changelog below is better.

Perfect, thanks.

Reviewed-by: Kevin Hilman <khilman@ti.com>

