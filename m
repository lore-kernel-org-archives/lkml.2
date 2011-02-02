Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1BBRCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:02:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:42770 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1BBRCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:02:18 -0500
Subject: Re: [PATCH 5/5] perf, x86: Add support for AMD family 15h core
 counters
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1296664860-10886-6-git-send-email-robert.richter@amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
	 <1296664860-10886-6-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 18:03:18 +0100
Message-ID: <1296666198.26581.343.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 17:41 +0100, Robert Richter wrote:
> +       unsigned int    eventsel;
> +       unsigned int    perfctr;
> +       unsigned int    *eventsel_map;
> +       unsigned int    *perfctr_map;
>         u64             (*event_map)(int);
>         int             max_events;
>         int             num_counters;
> @@ -323,11 +325,17 @@ again:
>  
>  static inline unsigned int x86_pmu_config_addr(int index)
>  {
> +       if (x86_pmu.eventsel_map)
> +               return x86_pmu.eventsel_map[index];
> +
>         return x86_pmu.eventsel + index;
>  }
>  
>  static inline unsigned int x86_pmu_event_addr(int index)
>  {
> +       if (x86_pmu.perfctr_map)
> +               return x86_pmu.perfctr_map[index];
> +
>         return x86_pmu.perfctr + index;
>  } 

Why this and not something like x86_pmu.perfctr + (index << 1)?
You could even use alternatives.



