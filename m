Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab1G2I50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:57:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63138 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab1G2I5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:57:25 -0400
Date: Fri, 29 Jul 2011 17:57:17 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: majordomo@kvack.org, P@draigBrady.com, mgorman@suse.de,
        linux-kernel@vger.kernel.org, andrea@cpushare.com,
        tim.c.chen@intel.com, shaohua.li@intel.com, akpm@linux-foundation.org,
        riel@redhat.com, luto@mit.edu
Subject: Re: [PATCH] kswapd: assign new_order and new_classzone_idx after
 wakeup in sleeping
Message-ID: <20110729085717.GC1843@barrios-desktop>
References: <1311903282-8539-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311903282-8539-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 09:34:42AM +0800, Alex Shi wrote:
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
> Paidrag Brady, Could like do a retry for your problem on this patch?
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
