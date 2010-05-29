Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0EaQec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:34:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:53767 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab0EaQeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:34:06 -0400
Subject: Re: [RFC] perf, x86: Segregate PMU workaraunds into
 x86_pmu_quirk_ops structure
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Robert Richter <robert.richter@amd.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@google.com>
In-Reply-To: <20100529182409.GJ5322@lenovo>
References: <20100529182409.GJ5322@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 May 2010 20:33:10 +0200
Message-ID: <1275157990.1645.519.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2010-05-29 at 22:24 +0400, Cyrill Gorcunov wrote:
> @@ -924,7 +930,11 @@ x86_perf_event_set_period(struct perf_ev
>          */
>         atomic64_set(&hwc->prev_count, (u64)-left);
>  
> -       wrmsrl(hwc->event_base + idx,
> +       if (x86_pmu.quirks.perfctr_write)
> +               x86_pmu.quirks.perfctr_write(hwc->event_base + idx,
> +                               (u64)(-left) & x86_pmu.cntval_mask);
> +       else
> +               wrmsrl(hwc->event_base + idx,
>                         (u64)(-left) & x86_pmu.cntval_mask);

This bit is rather ugly,.. not quite sure how to clean it up though.
Anybody got a bright idea?

