Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0ELRZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:25:19 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59930 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab0ELRZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:25:17 -0400
Message-ID: <4BEAE476.1090100@linux.vnet.ibm.com>
Date: Wed, 12 May 2010 10:25:10 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>
Subject: Re: [BUG] perf_event: when events are grouped, the time enabled /
 running values are incorrect
References: <4BE4C4BF.6020801@linux.vnet.ibm.com> <1273588935.1810.6.camel@laptop>
In-Reply-To: <1273588935.1810.6.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 07:42 AM, Peter Zijlstra wrote:
> ---
> Subject: perf: Fix exit() vs event-groups
> From: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Date: Tue May 11 16:19:10 CEST 2010
>
> Corey reported that the value scale times of group siblings are not
> updated when the monitored task dies.
>
> The problem appears to be that we only update the group leader's
> time values, fix it by updating the whole group.
>
> Reported-by: Corey Ashford<cjashfor@linux.vnet.ibm.com>
> Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras<paulus@samba.org>
> Cc: stable@kernel.org
> ---
>   kernel/perf_event.c |   44 +++++++++++++++++++++++---------------------
>   1 file changed, 23 insertions(+), 21 deletions(-)
>
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -255,6 +255,18 @@ static void update_event_times(struct pe
>   	event->total_time_running = run_end - event->tstamp_running;
>   }
>
> +/*
> + * Update total_time_enabled and total_time_running for all events in a group.
> + */
...

Peter,

Thanks for looking into this problem!  Unfortunately, I've been unable 
to test your patch.  It doesn't apply to 2.6.33.3 and so I tried the 
-tip tree (which has this patch committed).  The kernel built fine, but 
crashed almost immediately during the boot-up process on my Power5 machine.

I don't have the crash details at hand, but they didn't look related to 
this perf change.

- Corey
