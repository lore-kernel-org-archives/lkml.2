Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0KZJh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 04:37:27 -0500
Received: from service87.mimecast.com ([94.185.240.25]:48443 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751902Ab0KZJh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 04:37:26 -0500
Subject: Re: [PATCH v2 3/5] MIPS/Perf-events: Fix event check in
 validate_event()
From: Will Deacon <will.deacon@arm.com>
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com
In-Reply-To: <1290740707-32586-4-git-send-email-dengcheng.zhu@gmail.com>
References: <1290740707-32586-1-git-send-email-dengcheng.zhu@gmail.com>
	 <1290740707-32586-4-git-send-email-dengcheng.zhu@gmail.com>
Date: Fri, 26 Nov 2010 09:37:14 +0000
Message-ID: <1290764234.24565.1.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 26 Nov 2010 09:37:18.0615 (UTC) FILETIME=[848EF270:01CB8D4D]
X-MC-Unique: 110112609372102701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 03:05 +0000, Deng-Cheng Zhu wrote:
> Ignore events that are in off/error state or belong to a different PMU.
> 
> This patch originates from the following commit for ARM by Will Deacon:
> 
> 65b4711ff513767341aa1915c822de6ec0de65cb
>         ARM: 6352/1: perf: fix event validation
> 
> Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
> ---
>  arch/mips/kernel/perf_event.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
> index 1ee44a3..3d55761 100644
> --- a/arch/mips/kernel/perf_event.c
> +++ b/arch/mips/kernel/perf_event.c
> @@ -486,8 +486,9 @@ static int validate_event(struct cpu_hw_events *cpuc,
>  {
>         struct hw_perf_event fake_hwc = event->hw;
> 
> -       if (event->pmu && event->pmu != &pmu)
> -               return 0;
> +       /* Allow mixed event group. So return 1 to pass validation. */
> +       if (event->pmu != &pmu || event->state <= PERF_EVENT_STATE_OFF)
> +               return 1;
> 
>         return mipspmu->alloc_counter(cpuc, &fake_hwc) >= 0;
>  }


This looks better,

Acked-by: Will Deacon <will.deacon@arm.com>

Will


