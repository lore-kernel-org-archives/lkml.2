Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2IGPmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:42:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:37410 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2IGPmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:42:36 -0400
Message-ID: <1347032550.18408.92.camel@twins>
Subject: Re: [PATCH 1/3] perf: use hrtimer for event multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Date: Fri, 07 Sep 2012 17:42:30 +0200
In-Reply-To: <1347028169-1983-2-git-send-email-eranian@google.com>
References: <1347028169-1983-1-git-send-email-eranian@google.com>
	 <1347028169-1983-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 16:29 +0200, Stephane Eranian wrote:

Style nit:

> +	if (h->active)
> +		list_for_each_entry_safe(cpuctx, tmp, head, rotation_list)
> +			rotations += perf_rotate_context(cpuctx);


> +	if (!hrtimer_callback_running(hr))
> +		__hrtimer_start_range_ns(hr, ns_to_ktime(PERF_CPU_HRTIMER),
> +					 0, HRTIMER_MODE_REL_PINNED, 0);


All multi-line statements should be a stmt block, even if not strictly
required.
