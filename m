Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1HBLgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:36:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48289 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1HBLgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:36:06 -0400
Subject: Re: [PATCH 3/7] perf, x86: Implement IBS event configuration
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1311860812-28748-4-git-send-email-robert.richter@amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
	 <1311860812-28748-4-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 02 Aug 2011 13:35:33 +0200
Message-ID: <1312284933.1147.106.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
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
>   

It it intentional that you map the IBS things to the hw task_context ?


