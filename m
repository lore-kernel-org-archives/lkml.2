Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1DUBrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 21:47:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:30141 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab1DUBrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 21:47:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,249,1301900400"; 
   d="scan'208";a="912505467"
Date: Thu, 21 Apr 2011 09:47:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 3/6] writeback: sync expired inodes first in background
 writeback
Message-ID: <20110421014716.GA12191@localhost>
References: <20110419030003.108796967@intel.com>
 <20110419030532.515923886@intel.com>
 <20110419073523.GF23985@dastard>
 <20110419095740.GC5257@quack.suse.cz>
 <20110419125616.GA20059@localhost>
 <20110420012120.GK23985@dastard>
 <20110420073822.GA30672@localhost>
 <20110421010132.GE1814@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421010132.GE1814@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 09:01:32AM +0800, Dave Chinner wrote:
> On Wed, Apr 20, 2011 at 03:38:22PM +0800, Wu Fengguang wrote:
> > > make. Please test against a vanilla kernel if that is what you are
> > > aiming these patches for. If you aren't aiming for a vanilla kernel,
> > > please say so in the patch series header...
> > 
> > Here are the test results for vanilla kernel. It's again shows better
> > numbers for dd, tar and overall run time.
> > 
> >              2.6.39-rc3   2.6.39-rc3-dyn-expire+
> > ------------------------------------------------
> > all elapsed     256.043      252.367
> > stddev           24.381       12.530
> > 
> > tar elapsed      30.097       28.808
> > dd  elapsed      13.214       11.782
> 
> The big reduction in run-to-run variance is very convincing - moreso
> than the reduction in runtime - That's kind of what I had hoped
> would occur once I understood the implications of the change. Thanks
> for running the test to close the loop. :)

And you can see how the user perceivable variations in elapsed time
are reduced by the patchsets:

vanilla 
             user       system     %cpu       elapsed
stddev       0.000      0.037      0.539      0.805     dd,  xfs
stddev       0.117      0.102      5.974      3.498     tar, xfs

moving-target
stddev       0.000      0.102      1.025      0.803     dd,  xfs
stddev       0.131      0.136      4.415      2.136     tar, xfs

IO-less + moving-target 
stddev       0.000      0.022      0.000      0.283     dd,  xfs
stddev       0.000      0.031      0.000      0.151     dd,  ext4
stddev       0.111      0.218      2.040      0.532     tar, xfs
stddev       0.129      0.119      1.020      0.215     tar, ext4

Thanks,
Fengguang
