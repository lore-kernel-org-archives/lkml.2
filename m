Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab1INPfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:35:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:54596 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab1INPfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:35:38 -0400
Subject: Re: [PATCH 3/7] perf, x86: Implement IBS event configuration
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 14 Sep 2011 17:35:32 +0200
In-Reply-To: <1315413376-769-4-git-send-email-robert.richter@amd.com>
References: <1315413376-769-1-git-send-email-robert.richter@amd.com>
	 <1315413376-769-4-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316014532.5040.26.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 18:36 +0200, Robert Richter wrote:
> +static struct perf_ibs perf_ibs_fetch = {
> +       .pmu = {
> +               .event_init     = perf_ibs_init,
> +               .add            = perf_ibs_add,
> +               .del            = perf_ibs_del,
> +       },
> +       .msr                    = MSR_AMD64_IBSFETCHCTL,
> +       .config_mask            = IBS_FETCH_CONFIG_MASK,
> +       .cnt_mask               = IBS_FETCH_MAX_CNT,
> +       .enable_mask            = IBS_FETCH_ENABLE,
> +};
> +
> +static struct perf_ibs perf_ibs_op = {
> +       .pmu = {
> +               .event_init     = perf_ibs_init,
> +               .add            = perf_ibs_add,
> +               .del            = perf_ibs_del,
> +       },
> +       .msr                    = MSR_AMD64_IBSOPCTL,
> +       .config_mask            = IBS_OP_CONFIG_MASK,
> +       .cnt_mask               = IBS_OP_MAX_CNT,
> +       .enable_mask            = IBS_OP_ENABLE,
>  }; 

Both those .pmu things want:

  .task_ctx_nr = perf_invalid_context,

disabling per-task events, or you need to create a new context and
somehow fix per-task scheduling for these two things.

Adding two task contexts (one for each type) really isn't nice.
