Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab1G2Pdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:33:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:46539 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab1G2Pdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:33:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,287,1309762800"; 
   d="scan'208";a="33564656"
From: "Shi, Alex" <alex.shi@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "P@draigBrady.com" <P@draigBrady.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrea@cpushare.com" <andrea@cpushare.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "riel@redhat.com" <riel@redhat.com>, "luto@mit.edu" <luto@mit.edu>
Date: Fri, 29 Jul 2011 23:33:26 +0800
Subject: RE: [PATCH] kswapd: assign new_order and new_classzone_idx after
 wakeup in sleeping
Thread-Topic: [PATCH] kswapd: assign new_order and new_classzone_idx after
 wakeup in sleeping
Thread-Index: AcxNzYsSQOHVH2jGQyuLz8cmr9pJYgANujyw
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B5B69FE1A4F@shsmsx502.ccr.corp.intel.com>
References: <1311903282-8539-1-git-send-email-alex.shi@intel.com>
 <20110729085717.GC1843@barrios-desktop>
In-Reply-To: <20110729085717.GC1843@barrios-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Minchan Kim [mailto:minchan.kim@gmail.com]
> Sent: Friday, July 29, 2011 4:57 PM
> To: Shi, Alex
> Cc: majordomo@kvack.org; P@draigBrady.com; mgorman@suse.de;
> linux-kernel@vger.kernel.org; andrea@cpushare.com; Chen, Tim C; Li,
> Shaohua; akpm@linux-foundation.org; riel@redhat.com; luto@mit.edu
> Subject: Re: [PATCH] kswapd: assign new_order and new_classzone_idx after
> wakeup in sleeping
> 
> On Fri, Jul 29, 2011 at 09:34:42AM +0800, Alex Shi wrote:
> > There 2 place to read pgdat in kswapd. One is return from a successful
> > balance, another is waked up from sleeping. But the new_order and
> > new_classzone_idx are not assigned after kswapd_try_to_sleep(), that
> > will cause a bug in the following scenario.
> >
> > After the last time successful balance, kswapd goes to sleep. So the
> > new_order and new_classzone_idx were assigned to 0 and MAX-1 since there
> > is no new wakeup during last time balancing. Now, a new wakeup came and
> > finish balancing successful with order > 0. But since new_order is still
> > 0, this time successful balancing were judged as a failed balance. so,
> > if there is another new wakeup coming during balancing, kswapd cann't
> > read this and still want to try to sleep. And if the new wakeup is a
> > tighter request, kswapd may goes to sleep, not to do balancing. That is
> > incorrect.
> >
> > So, to avoid above problem, the new_order and new_classzone_idx need to
> > be assigned for later successful comparison.
> >
> > Paidrag Brady, Could like do a retry for your problem on this patch?
> >
> > Signed-off-by: Alex Shi <alex.shi@intel.com>
> > Acked-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Thanks for review. 
BTW, I remove the incorrect email address of linux-mm. sorry for this! 
