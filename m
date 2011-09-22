Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1IVVvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:51:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:38746 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1IVVve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:51:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,425,1312182000"; 
   d="scan'208";a="62858673"
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [V3][PATCH 4/7] perf, x86: Implement IBS interrupt handler
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
	<1316597423-25723-5-git-send-email-robert.richter@amd.com>
Date: Thu, 22 Sep 2011 14:51:34 -0700
In-Reply-To: <1316597423-25723-5-git-send-email-robert.richter@amd.com>
	(Robert Richter's message of "Wed, 21 Sep 2011 11:30:20 +0200")
Message-ID: <m2litgjleh.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter <robert.richter@amd.com> writes:
>  
> +static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
> +{
> +	struct perf_event *event = NULL;
> +	struct hw_perf_event *hwc = &event->hw;
> +	struct perf_sample_data data;
> +	struct perf_raw_record raw;
> +	struct pt_regs regs;
> +	struct perf_ibs_data ibs_data;
> +	int offset, size;
> +	unsigned int msr;
> +	u64 *buf;
> +
> +	msr = hwc->config_base;
> +	buf = ibs_data.regs;
> +	rdmsrl(msr, *buf);
> +	if (!(*buf++ & perf_ibs->valid_mask))
> +		return 0;

No check if the NMI is really caused by IBS? Very nasty.
This will not interoperate well with other NMIs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
