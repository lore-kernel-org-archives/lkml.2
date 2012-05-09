Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab2EIGjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:39:03 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:44187 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2EIGjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:39:00 -0400
Message-ID: <4FAA10FB.1030008@linux.vnet.ibm.com>
Date: Wed, 09 May 2012 12:08:51 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Yan, Zheng" <zheng.z.yan@intel.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] perf: Allow pmu to choose cpu on which to install
 event
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com> <1335924440-11242-3-git-send-email-zheng.z.yan@intel.com>
In-Reply-To: <1335924440-11242-3-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050906-3864-0000-0000-000002AE6F07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2012 07:37 AM, Yan, Zheng wrote:

> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Allow the pmu->event_init callback to change event->cpu, so pmu can
> choose cpu on which to install event.
> 
> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> ---
>  kernel/events/core.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 32cfc76..84911de 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6250,6 +6250,8 @@ SYSCALL_DEFINE5(perf_event_open,
>  		}
>  	}
> 
> +	get_online_cpus();

Why this protection against cpu hotplug operation ? Is this because PMU now can change event->cpu
during event initialization (specific to uncore PMU events) or this protection has always been required
for normal on-cpu HW PMU events also and we added it right now ?

