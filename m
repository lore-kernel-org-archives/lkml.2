Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab0G1CEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 22:04:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:21787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab0G1CEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 22:04:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,271,1278313200"; 
   d="scan'208";a="822341957"
Date: Wed, 28 Jul 2010 10:04:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] writeback: reduce calls to global_page_state in
 balance_dirty_pages()
Message-ID: <20100728020407.GA9819@localhost>
References: <20100711020656.340075560@intel.com>
 <20100711021748.735126772@intel.com>
 <20100726151946.GH3280@quack.suse.cz>
 <20100727035941.GA15007@localhost>
 <20100727091220.GD3358@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727091220.GD3358@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The global threshold check is added in place of clip_bdi_dirty_limit()
> > for safety and not intended as a behavior change. If ever leading to
> > big behavior change and regression, that it would be indicating some
> > too permissive per-bdi threshold calculation.
> > 
> > Did you see the global dirty threshold get exceeded when writing to 2+
> > devices? Occasional small exceeding should be OK though. I tried the
> > following debug patch and see no warnings when doing two concurrent cp
> > over local disk and NFS.
>   Oops, sorry. I've misread the code. You're right. There shouldn't be a big
> change in the behavior.

It does indicate a missing point in the changelog. The paragraph is
updated to:

        We now set and clear dirty_exceeded not only based on bdi dirty limits,
        but also on the global dirty limit. The global limit check is added in
        place of clip_bdi_dirty_limit() for safety and not intended as a
        behavior change. The bdi limits should be tight enough to keep all dirty
        pages under the global limit at most time; occasional small exceeding
        should be OK though. The change makes the logic more obvious: the global
        limit is the ultimate goal and shall be always imposed.

Thanks,
Fengguang
