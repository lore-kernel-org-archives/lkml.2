Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab2K0MLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:11:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59297 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab2K0MLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:11:07 -0500
Date: Tue, 27 Nov 2012 13:10:51 +0100
From: Robert Richter <rric@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] perf, amd: Enable northbridge performance counters
 on AMD family 15h
Message-ID: <20121127121051.GF1877@rric.localhost>
References: <1353970111-4508-1-git-send-email-jacob.shin@amd.com>
 <1353970111-4508-5-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353970111-4508-5-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One minor comment:

On 26.11.12 16:48:30, Jacob Shin wrote:
>  __init int amd_pmu_init(void)
>  {
>  	/* Performance-monitoring supported from K7 and later: */
> @@ -666,6 +749,10 @@ __init int amd_pmu_init(void)
>  	setup_event_constraints();
>  	setup_perfctr_core();
>  
> +	num_core_counters = x86_pmu.num_counters;

I would better move this to setup_perfctr_nb().

> +
> +	setup_perfctr_nb();
> +
>  	/* Events are common for all AMDs */
>  	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
>  	       sizeof(hw_cache_event_ids));

Otherwise the whole patch set looks good.

Acked-by: Robert Richter <rric@kernel.org>

Thanks Jacob.

-Robert
