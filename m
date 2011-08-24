Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1HXDQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 23:16:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:13548 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab1HXDQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 23:16:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,273,1312182000"; 
   d="scan'208";a="41755527"
Date: Wed, 24 Aug 2011 11:16:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110824031603.GA30873@localhost>
References: <20110816022006.348714319@intel.com>
 <20110816022328.811348370@intel.com>
 <20110816194112.GA25517@quack.suse.cz>
 <20110817132347.GA6628@localhost>
 <20110817202414.GK9959@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817202414.GK9959@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +	x_intercept = setpoint + 2 * span;
>    ^^ BTW, why do you have 2*span here? It can result in x_intercept being
> ~3*bdi_thresh... So maybe you should use bdi_thresh/2 in the computation of
> span?

OK, I'll follow your suggestion to use

        span = 8 * write_bw, for single bdi case 
        span = bdi_thresh, for JBOD case
        x_intercept = setpoint + span;

It does make sense to squeeze the bdi_dirty fluctuation range a bit by
doubling span and making the control line more sharp.

Thanks,
Fengguang
