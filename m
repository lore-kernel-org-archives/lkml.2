Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab0I1Ifb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:35:31 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39418 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0I1If3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:35:29 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.147.230]
In-Reply-To: <201009222049.18154.rjw@sisk.pl>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
	<201009180026.59482.trenn@suse.de>
	<AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
	<201009222049.18154.rjw@sisk.pl>
Date: Tue, 28 Sep 2010 10:35:27 +0200
Message-ID: <AANLkTinJU5+s_1S6i4GpRuiOfsAPiL9UFtrxCCbtoumt@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is what I am proposing, in reply to all your comments:

1) rename the events to match Thomas's proposal:
   power:power_cpu_cstate
   power:power_cpu_pstate
   power:power_cpu_sstate
   ...

2) introduce a new Kconfig option CONFIG_DEPRECATED_POWER_EVENTS and
conditionally map a subset of the new events to the old ones for
backward compatibility with the existing user apps. The apps should be
converted to the new API asap,

3) update documentation

Other remarks here below:

On Wed, Sep 22, 2010 at 8:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
...
> This POWER_SSTATE thing seems to be totally artificial and omap-specific.
>
> Why do you want it to be done this way?
>
> Or is the ACPI handling added in the ACPI patch?  In which case, why don't you
> put that power_switch_state(POWER_SSTATE, 1, 0, cpu) into
> kernel/power/suspend.c:suspend_enter() (and analogously for
> power_switch_state(POWER_SSTATE, 0, 0, cpu)).
The ACPI code is not using the SSTATE event.
Indeed inserting a tracepoint at
kernel/power/suspend.c:suspend_enter() is more generic. I will correct
this.

> Moreover, why is the cpu argument necessary for POWER_SSTATE at all?
The cpu_id parameter is present in all events prototypes. This is not
needed. I will correct this.

>
> Thanks,
> Rafael
>

A new patch should be ready in the coming days. I would like to have
your opinion on the proposed rework before re-doing it all again.

Thanks,
Jean
