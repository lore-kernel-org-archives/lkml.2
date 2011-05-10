Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab1EJOsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:48:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab1EJOr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:47:58 -0400
Subject: Re: [PATCH 2/3] perf, x86: Use GO/HO bits in perf-ctr
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        benh <benh@kernel.crashing.org>, Anton Blanchard <anton@samba.org>,
        davem <davem@davemloft.net>
In-Reply-To: <1305038132-5080-3-git-send-email-joerg.roedel@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
	 <1305038132-5080-3-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 16:48:20 +0200
Message-ID: <1305038900.2914.97.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> The AMD perf-counters support counting in guest or host-mode
> only. Make use of that feature when user-space specified
> guest/host-mode only counting.

Subject mentions x86, does Intel have anything similar so you can make
it work for them too?

Also, might be nice to ask the power and sparc64 people if their archs
can also differentiate between guest and host thingies.

> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index cf4e369..afc21f3 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -116,6 +116,12 @@ static int amd_pmu_hw_config(struct perf_event *event)
>         if (ret)
>                 return ret;
>  
> +       if (event->attr.exclude_host)
> +               event->hw.config |= AMD_PERFMON_EVENTSEL_GUESTONLY;
> +
> +       if (event->attr.exclude_guest)
> +               event->hw.config |= AMD_PERFMON_EVENTSEL_HOSTONLY;
> +
>         if (event->attr.type != PERF_TYPE_RAW)
>                 return 0;

