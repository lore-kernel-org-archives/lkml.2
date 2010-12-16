Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab0LPG6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 01:58:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:23562 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab0LPG6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 01:58:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,354,1288594800"; 
   d="scan'208";a="868795699"
Date: Thu, 16 Dec 2010 14:33:22 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ai Li <aili@codeaurora.org>
Cc: akpm@linux-foundation.org, dwalker@codeaurora.org, arjan@linux.intel.com,
        mingo@elte.hu, shemminger@vyatta.com, czoccolo@gmail.com,
        len.brown@intel.com, h.peter.anvin@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH v3] cpuidle: extend cpuidle and menu governor to handle
	dynamic states
Message-ID: <20101216063322.GA18025@ywang-moblin2.bj.intel.com>
References: <1280504951-27812-1-git-send-email-aili@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280504951-27812-1-git-send-email-aili@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 09:49:11AM -0600, Ai Li wrote:
> On some SoC chips, HW resources may be in use during any particular idle
> period.  As a consequence, the cpuidle states that the SoC is safe to
> enter can change from idle period to idle period.  In addition, the
> latency and threshold of each cpuidle state can vary, depending on the
> operating condition when the CPU becomes idle, e.g. the current cpu
> frequency, the current state of the HW blocks, etc.
> 
> cpuidle core and the menu governor, in the current form, are geared
> towards cpuidle states that are static, i.e. the availabiltiy of the
> states, their latencies, their thresholds are non-changing during run
> time.  cpuidle does not provide any hook that cpuidle drivers can use
> to adjust those values on the fly for the current idle period before the
> menu governor selects the target cpuidle state.
> 
> This patch extends cpuidle core and the menu governor to handle states
> that are dynamic.  There are three additions in the patch and the patch
> maintains backwards-compatibility with existing cpuidle drivers.
> 
> 1) add prepare() to struct cpuidle_device.  A cpuidle driver can hook
> into the callback and cpuidle will call prepare() before calling the
> governor's select function.  The callback gives the cpuidle driver a
> chance to update the dynamic information of the cpuidle states for the
> current idle period, e.g. state availability, latencies, thresholds,
> power values, etc.
> 

Could you please point me to some sample code regarding how to use this
'prepare' callback?

> +
> +	/*
> +	 * Call the device's prepare function before calling the
> +	 * governor's select function.  ->prepare gives the device's
> +	 * cpuidle driver a chance to update any dynamic information
> +	 * of its cpuidle states for the current idle period, e.g.
> +	 * state availability, latencies, residencies, etc.
> +	 */
> +	if (dev->prepare)
> +		dev->prepare(dev);
> +
>  	/* ask the governor for the next state */
>  	next_state = cpuidle_curr_governor->select(dev);

In terms of dynamic states, what if situation changes between the
'prepare' callback and the selected state is actually entered? Like a
particular state makes sense when 'prepare' is called but does not make
sense any more when cpuidle actually tries to enter that state?

Thanks
-Yong

