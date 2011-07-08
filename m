Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1GHOQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:16:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:20834 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab1GHOPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:15:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,499,1304319600"; 
   d="scan'208";a="27870321"
Date: Fri, 8 Jul 2011 04:51:07 -0700
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] writeback: introduce smoothed global dirty limit
Message-ID: <20110708115107.GA6159@localhost>
References: <20110701152048.GA2721@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701152048.GA2721@thinkpad>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (now - update_time < MAX_PAUSE)
> 
> 	if (time_before(now, update_time + MAX_PAUSE))
> 
> > +		return;
> > +
> > +	spin_lock(&dirty_lock);
> > +	if (now - update_time >= MAX_PAUSE) {
> 
> 	if (time_after_eq(now, update_time + MAX_PAUSE))

Changed, thanks!
