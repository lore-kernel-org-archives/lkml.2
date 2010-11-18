Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab0KRJ2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:28:47 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47538 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754190Ab0KRJ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:28:44 -0500
Subject: Re: [PATCH 5/5] MIPS/Perf-events: Use unsigned delta for right
 shift in event update
From: Will Deacon <will.deacon@arm.com>
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com
In-Reply-To: <1290063401-25440-6-git-send-email-dengcheng.zhu@gmail.com>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
	 <1290063401-25440-6-git-send-email-dengcheng.zhu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 09:27:38 +0000
Message-ID: <1290072458.18450.1.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 09:27:42.0299 (UTC) FILETIME=[D9BE1AB0:01CB8702]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 06:56 +0000, Deng-Cheng Zhu wrote:
> Leverage the commit for ARM by Will Deacon:
> 
> 446a5a8b1eb91a6990e5c8fe29f14e7a95b69132
>         ARM: 6205/1: perf: ensure counter delta is treated as unsigned
> 
> Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
> ---
>  arch/mips/kernel/perf_event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
> index 345232a..0f1cdf5 100644
> --- a/arch/mips/kernel/perf_event.c
> +++ b/arch/mips/kernel/perf_event.c
> @@ -169,7 +169,7 @@ static void mipspmu_event_update(struct perf_event *event,
>         unsigned long flags;
>         int shift = 64 - TOTAL_BITS;
>         s64 prev_raw_count, new_raw_count;
> -       s64 delta;
> +       u64 delta;
> 
>  again:
>         prev_raw_count = local64_read(&hwc->prev_count);
> --
> 1.7.1

Acked-by: Will Deacon <will.deacon@arm.com>

You might also want to look at commit 65b4711f if you based
the MIPS port on the old ARM code.

Thanks,

Will

