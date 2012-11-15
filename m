Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885Ab2KOKwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:52:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62524 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838Ab2KOKwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:52:25 -0500
Message-ID: <50A4C963.9060808@linaro.org>
Date: Thu, 15 Nov 2012 11:52:19 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Sameer Nanda <snanda@chromium.org>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] cpuidle: Measure idle state durations with monotonic
 clock
References: <CAODwPW873M32d9zFT9fpJT9+PuMbz8htzUxdF1TNE+J1zR3jYA@mail.gmail.com> <1352944590-8776-1-git-send-email-jwerner@chromium.org>
In-Reply-To: <1352944590-8776-1-git-send-email-jwerner@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 02:56 AM, Julius Werner wrote:
> Many cpuidle drivers measure their time spent in an idle state by
> reading the wallclock time before and after idling and calculating the
> difference. This leads to erroneous results when the wallclock time gets
> updated by another processor in the meantime, adding that clock
> adjustment to the idle state's time counter.
> 
> If the clock adjustment was negative, the result is even worse due to an
> erroneous cast from int to unsigned long long of the last_residency
> variable. The negative 32 bit integer will zero-extend and result in a
> forward time jump of roughly four billion milliseconds or 1.3 hours on
> the idle state residency counter.
> 
> This patch changes all affected cpuidle drivers to either use the
> monotonic clock for their measurements or make use of the generic time
> measurement wrapper in cpuidle.c, which was already working correctly.
> Some superfluous CLIs/STIs in the ACPI code are removed (interrupts
> should always already be disabled before entering the idle function, and
> not get reenabled until the generic wrapper has performed its second
> measurement). It also removes the erroneous cast, making sure that
> negative residency values are applied correctly even though they should
> not appear anymore.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>

Tested on a Core 2 Duo (processor_idle driver).

Tested-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

