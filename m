Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710Ab2ILOxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:53:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758854Ab2ILOxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:53:22 -0400
Message-ID: <5050A1D8.5080104@redhat.com>
Date: Wed, 12 Sep 2012 10:53:12 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH] time: Fix timeekeping_get_ns overflow on 32bit systems
References: <1347405963-35715-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1347405963-35715-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/11/2012 07:26 PM, John Stultz wrote:
> Thomas: Please queue this in tip/timers/urgent for 3.6.
> 
> Daniel Lezcano reported seeing multi-second stalls from
> keyboard input on his T61 laptop when NOHZ and CPU_IDLE
> were enabled on a 32bit kernel.
> 
> He bisected the problem down to
> 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1 (time: Condense
> timekeeper.xtime into xtime_sec).
> 
> After reproducing this issue, I narrowed the problem down
> to the fact that timekeeping_get_ns() returns a 64bit
> nsec value that hasn't been accumulated. In some cases
> this value was being then stored in timespec.tv_nsec
> (which is a long).
> 
> On 32bit systems, With idle times larger then 4 seconds
> (or less, depending on the value of xtime_nsec), the
> returned nsec value would overflow 32bits. This limited
> kept time from increasing, causing timers to not expire.
> 
> The fix is to make sure we don't directly store the
> result of timekeeping_get_ns() into a tv_nsec field,
> instead using a 64bit nsec value which can then be
> added into the timespec via timespec_add_ns().
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Reported-and-bisected-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Tested-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Acked-by: Prarit Bhargava <prarit@redhat.com>

P.
