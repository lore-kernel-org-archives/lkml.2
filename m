Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2K0GOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:14:36 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44200 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2K0GOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:14:34 -0500
Message-ID: <50B45A47.9050600@kernel.org>
Date: Tue, 27 Nov 2012 01:14:31 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Preeti Murthy <preeti.lkml@gmail.com>
CC: Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Sameer Nanda <snanda@chromium.org>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] cpuidle: Measure idle state durations with monotonic
 clock
References: <CAODwPW873M32d9zFT9fpJT9+PuMbz8htzUxdF1TNE+J1zR3jYA@mail.gmail.com> <1352944590-8776-1-git-send-email-jwerner@chromium.org> <CAM4v1pPhaP=pVnFMXUU_nmrOxhY5yPNtbBdQsT5MH37MndK6LQ@mail.gmail.com>
In-Reply-To: <CAM4v1pPhaP=pVnFMXUU_nmrOxhY5yPNtbBdQsT5MH37MndK6LQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 04:04 AM, Preeti Murthy wrote:
> Hi all,
> 
> The code looks correct and inviting to me as it has led to good cleanups.
> I dont think passing 0 as the argument to the function
> sched_clock_idle_wakeup_event()
> should lead to problems,as it does not do anything useful with the
> passed arguments.
> 
> My only curiosity is what was the purpose of passing idle residency time to
> sched_clock_idle_wakeup_event() when this data could always be retrieved from
> dev->last_residency for each cpu,which gets almost immediately updated.

sched_clock_idle_wakeup_event() is part of the scheduler.
The scheduler doesn't know what a cpuidle_device is, and
probably should not grow such a dependency.

cheers,
-Len Brown, Intel Open Source Technology Center

> But this does not seem to come in way of this patch for now.Anyway I
> have added Peter to
> the list so that he can opine about this issue if possible and needed.
> 
> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> 
> 
> Regards
> Preeti U Murthy
> 

