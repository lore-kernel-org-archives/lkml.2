Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1GHOPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:15:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:20834 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab1GHOPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:15:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,499,1304319600"; 
   d="scan'208";a="27870318"
Date: Fri, 8 Jul 2011 04:53:35 -0700
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] writeback: bdi write bandwidth estimation
Message-ID: <20110708115335.GB6159@localhost>
References: <20110701152005.GA13445@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701152005.GA13445@thinkpad>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea,

> Another small time nitpick.
> 
> > +
> > +static void bdi_update_bandwidth(struct backing_dev_info *bdi,
> > +				 unsigned long start_time)
> > +{
> > +	if (jiffies - bdi->bw_time_stamp <= MAX_PAUSE + MAX_PAUSE / 10)
> 
> 	if (time_is_after_eq_jiffies(bdi->bw_time_stamp + MAX_PAUSE +
> 						MAX_PAUSE / 10)

Done, and simplified to

        if (time_is_after_eq_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
                return;

Thanks,
Fengguang
