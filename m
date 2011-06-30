Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1F3WKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:10:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:48059 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab1F3WK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:10:27 -0400
Subject: Re: [PATCH 2/4] perf, x86: Add Intel SandyBridge uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1309421396-17438-3-git-send-email-ming.m.lin@intel.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	 <1309421396-17438-3-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Jul 2011 00:09:18 +0200
Message-ID: <1309471758.12449.628.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 08:09 +0000, Lin Ming wrote:
> +static struct uncore_config {
> +       unsigned long config_base;
> +       unsigned long event_base;
> +} snb_uncore_configs[SNB_UNCORE_NUM_COUNTERS] = {
> +       {SNB_MSR_UNC_CBO_0_PERFEVTSEL0, SNB_MSR_UNC_CBO_0_PER_CTR0},
> +       {SNB_MSR_UNC_CBO_0_PERFEVTSEL1, SNB_MSR_UNC_CBO_0_PER_CTR1},
> +       {SNB_MSR_UNC_CBO_1_PERFEVTSEL0, SNB_MSR_UNC_CBO_1_PER_CTR0},
> +       {SNB_MSR_UNC_CBO_1_PERFEVTSEL1, SNB_MSR_UNC_CBO_1_PER_CTR1},
> +       {SNB_MSR_UNC_CBO_2_PERFEVTSEL0, SNB_MSR_UNC_CBO_2_PER_CTR0},
> +       {SNB_MSR_UNC_CBO_2_PERFEVTSEL1, SNB_MSR_UNC_CBO_2_PER_CTR1},
> +       {SNB_MSR_UNC_CBO_3_PERFEVTSEL0, SNB_MSR_UNC_CBO_3_PER_CTR0},
> +       {SNB_MSR_UNC_CBO_3_PERFEVTSEL1, SNB_MSR_UNC_CBO_3_PER_CTR1},
> +};

> +static int snb_uncore_pmu_hw_config(struct perf_event *event)
> +{
> +       struct hw_perf_event *hwc = &event->hw;
> +       int i = hwc->idx;
> +
> +       hwc->config = event->attr.config & SNB_UNCORE_RAW_EVENT_MASK;
> +       hwc->config_base = snb_uncore_configs[i].config_base;

	hwc->config_base = SNB_MSR_UNC_CBO_0_PERFEVTSEL0 + 
		0x10 * (i >> 1) + 0x6 * (i & 1);

Saves a memory lookup, might or might not be worth it.

What the heck did Intel mess those MSRs up for anyway?

> +       hwc->event_base = snb_uncore_configs[i].event_base;
> +
> +       return 0;
> +} 


