Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1G1KTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:19:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab1G1KTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:19:47 -0400
Date: Thu, 28 Jul 2011 11:19:43 +0100
From: Mel Gorman <mgorman@suse.de>
To: Alex Shi <alex.shi@intel.com>
Cc: minchan.kim@gmail.com, stable@kernel.org, linux-kernel@vger.kernel.org,
        andrea@cpushare.com, tim.c.chen@intel.com, shaohua.li@intel.com
Subject: Re: [PATCH] kswapd: assign new_order and new_classzone_idx after
 wakeup in sleeping
Message-ID: <20110728101943.GI3010@suse.de>
References: <1311840688-11388-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1311840688-11388-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 04:11:28PM +0800, Alex Shi wrote:
> There 2 place to read pgdat in kswapd. One is return from a successful
> balance, another is waked up from sleeping. But the new_order and
> new_classzone_idx are not assigned after kswapd_try_to_sleep(), that
> will cause a bug in the following scenario.
> 
> After the last time successful balance, kswapd goes to sleep. So the
> new_order and new_classzone_idx were assigned to 0 and MAX-1 since there
> is no new wakeup during last time balancing. Now, a new wakeup came and
> finish balancing successful with order > 0. But since new_order is still
> 0, this time successful balancing were judged as a failed balance. so,
> if there is another new wakeup coming during balancing, kswapd cann't
> read this and still want to try to sleep. And if the new wakeup is a
> tighter request, kswapd may goes to sleep, not to do balancing. That is
> incorrect.
> 
> So, to avoid above problem, the new_order and new_classzone_idx need to
> be assigned for later successful comparison.
> 

Other than a different changelog, this is identical to
https://lkml.org/lkml/2011/6/30/157 so

Acked-by: Mel Gorman <mgorman@suse.de>

It won't be merged to -stable until it goes to mainline though so
minimally you need to post this to linux-mm.

For -stable, you should explain why it is a candidate. I didn't push
the patch at the time because user problems were already resolved
and I wanted the merged for 3.0 before revisiting it. What problem
did you observe without this patch? With the lack of reference to
the other thread or the previous patch, I'm assuming you found and
solved the problem independently and I'd like to add a test case.

Thanks.

-- 
Mel Gorman
SUSE Labs
