Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0I1Vn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:43:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64053 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0I1Vn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:43:57 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.147.230]
In-Reply-To: <201009282322.16291.rjw@sisk.pl>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
	<201009222049.18154.rjw@sisk.pl>
	<AANLkTinJU5+s_1S6i4GpRuiOfsAPiL9UFtrxCCbtoumt@mail.gmail.com>
	<201009282322.16291.rjw@sisk.pl>
Date: Tue, 28 Sep 2010 23:43:55 +0200
Message-ID: <AANLkTin7yoSArdMTMSxKyamMP-dk7bubPiCEgWGb6RCc@mail.gmail.com>
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

On Tue, Sep 28, 2010 at 11:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, September 28, 2010, Jean Pihet wrote:
>> Hi,
>
> Hi,
>
>> Here is what I am proposing, in reply to all your comments:
>>
>> 1) rename the events to match Thomas's proposal:
>>    power:power_cpu_cstate
>>    power:power_cpu_pstate
>>    power:power_cpu_sstate
>
> If that sstate thing is going to mean "suspend", then please drop it.
> "Suspend" is not a state, let alone a CPU state.  It is a procedure by which
> the (entire) system is put into a sleep state (that is not confined to CPUs).

Since suspend is tied to the power management of the system, is it ok
to rename it to e.g. power:system_suspend?

>
>>    ...
>>
>> 2) introduce a new Kconfig option CONFIG_DEPRECATED_POWER_EVENTS and
>> conditionally map a subset of the new events to the old ones for
>> backward compatibility with the existing user apps. The apps should be
>> converted to the new API asap,
>>
>> 3) update documentation
>
> Sounds reasonable.
OK

>
>> Other remarks here below:
>>
>> On Wed, Sep 22, 2010 at 8:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> ...
>> > This POWER_SSTATE thing seems to be totally artificial and omap-specific.
>> >
>> > Why do you want it to be done this way?
>> >
>> > Or is the ACPI handling added in the ACPI patch?  In which case, why don't you
>> > put that power_switch_state(POWER_SSTATE, 1, 0, cpu) into
>> > kernel/power/suspend.c:suspend_enter() (and analogously for
>> > power_switch_state(POWER_SSTATE, 0, 0, cpu)).
>> The ACPI code is not using the SSTATE event.
>> Indeed inserting a tracepoint at
>> kernel/power/suspend.c:suspend_enter() is more generic. I will correct
>> this.
>
> OK
>
>> > Moreover, why is the cpu argument necessary for POWER_SSTATE at all?
>> The cpu_id parameter is present in all events prototypes. This is not
>> needed. I will correct this.
>
> OK
>
> Thanks,
> Rafael
>

Thanks,
Jean
