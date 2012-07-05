Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2GEOvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:51:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46136 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2GEOvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:51:31 -0400
Date: Thu, 5 Jul 2012 16:51:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 5/5] perf/x86: Add Intel Nehalem-EX uncore support
Message-ID: <20120705145124.GS11413@one.firstfloor.org>
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com> <1341381616-12229-6-git-send-email-zheng.z.yan@intel.com> <1341396293.2507.77.camel@laptop> <4FF534F1.3030307@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF534F1.3030307@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 02:32:17PM +0800, Yan, Zheng wrote:
> The uncore subsystem in Nehalem-EX consists of 7 components
> (U-Box, C-Box, B-Box, S-Box, R-Box, M-Box and W-Box). This
> patch is large because the way to program these boxes is
> diverse.

Thanks for doing the driver. Lots of work.

May be worth adding a CONFIG for the uncore code now?
Maybe even a module, so that not every distro kernel has it always
in memory. I don't think perf has support for tracking
module counts, but I guess it would be ok to have the module be not
unloadable once loaded by setting the count to -1.

Also did you do some random testing by putting randomized values into
all the exported registers and see if anything is crashable for 
unpriv. userspace?

> +		 * events are functional identical, but use different
> +		 * extra registers. If we failed to take an extra
> +		 * register, try the alternative.
> +		 */
> +		if (idx % 2)
> +			idx--;
> +		else
> +			idx++;
> +		if (idx != reg1->idx % 6) {
> +			if (idx == 2)
> +				config1 >>= 8;
> +			else if (idx == 3)
> +				config1 <<= 8;
> +			goto again;

Does this limit the retries?

> @@ -1767,6 +2821,9 @@ static int __init uncore_cpu_init(void)
>  			snbep_uncore_cbox.num_boxes = max_cores;
>  		msr_uncores = snbep_msr_uncores;
>  		break;
> +	case 46:
> +		msr_uncores = nhmex_msr_uncores;
> +		break;

Ok need Westmere-EX too. I think that is quite similar.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
