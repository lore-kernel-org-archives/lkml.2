Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab0ICSFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 14:05:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756984Ab0ICSFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 14:05:12 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Fri, 3 Sep 2010 20:05:07 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <len.brown@intel.com>,
        Arjan Van De Ven <arjan@linux.intel.com>, arjan@infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com> <AANLkTinaBJqY0UaMnwJa0nfeNYDm2Dw2t_pBsoGsraHL@mail.gmail.com> <AANLkTikg70zAHyA9pcWybz7SsQSPOuzUeuBdwX1cs+MP@mail.gmail.com>
In-Reply-To: <AANLkTikg70zAHyA9pcWybz7SsQSPOuzUeuBdwX1cs+MP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009032005.08268.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

Summary at the beginning if people stop reading on the details
below...:
Nice work!
You have my vote to get this merged.
I think it's up to Ingo to push it.


Ehh, the patch you send misses the sleep state tracing event
which shows up on the link you point to below, but this can
be sent as a separate patch as well:

--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -13,9 +13,14 @@ enum {
 	POWER_NONE = 0,
 	POWER_CSTATE = 1,
 	POWER_PSTATE = 2,
+	POWER_SSTATE = 3,
 };
 #endif
 
On Friday 03 September 2010 19:00:32 Jean Pihet wrote:
> Hi,
> 
> I would like to get some feedback on the code or on the new events
> definition, cf. proposed patch in this thread.
> 
> The idea is to provide new events for power management, as indicated
> at http://www.omappedia.com/wiki/Power_Management_Debug_and_Profiling
now I get why I got CC'ed..., the cpufreq perf events work on ARM since
git commit 6f4f2723d08534fd4e407e1ef8500b0f4d12c30c
right?

I can't judge the ARM specific things in detail, let me try to compare
this with X86 as your concern is that your patch is touching a generic
interface:

Power Domain events:
I doubt that power domains or something similar shows up on x86
any time soon. So if this fits for ARM, why not adding it...

Clock Events:
Hm, this could fit with throttling states.
But it's not worth adding for X86 (might get controlled by HW on
critical thermal conditions and with the p4_clockmod driver which should 
not exist, this would show up as P-states).
But in theory those could get re-used on X86.

New POWER_SSTATE event:
The sleep state tracing might not be that interesting for X86 where you
realize when you sleep, but sounds reasonable for a mobile phone where
there could exist sleeping states in which you could still get phone 
calls or similar?
If we had sleep states for x86 servers one could track how often a data
center workload manager has put backup machines to sleep. Will not 
happen any time soon unless someone builds a laptop server farm, but
yes, sounds like a useful thing depending on architecture and what you
want to do with your machine...

> As soon as the new events are defined -i.e. accepted in the mainline
> code- the tracepoints will be added for ARM/OMAP.
> 
> Any idea, remark or feedback welcome!
Again: nice work.

      Thomas
