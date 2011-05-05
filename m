Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1EEMsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:48:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:10590 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab1EEMsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,319,1301900400"; 
   d="scan'208";a="688588148"
Date: Thu, 5 May 2011 20:48:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/3] writeback: avoid extra sync work at enqueue time
Message-ID: <20110505124847.GA5623@localhost>
References: <20110502031750.135798606@intel.com>
 <20110502033035.789279347@intel.com>
 <20110504212427.GI6968@quack.suse.cz>
 <20110505122732.GC1294@localhost>
 <20110505124122.GA24009@lst.de>
 <20110505124237.GB24009@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505124237.GB24009@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 08:42:37PM +0800, Christoph Hellwig wrote:
> On Thu, May 05, 2011 at 02:41:22PM +0200, Christoph Hellwig wrote:
> > On Thu, May 05, 2011 at 08:27:32PM +0800, Wu Fengguang wrote:
> > > -	wbc.wb_start = jiffies; /* livelock avoidance */
> > > +	oldest_jif = jiffies;
> > > +	wbc.older_than_this = &oldest_jif;
> > 
> > Can't you kill the oldest_jif variable now?
> 
> Err, -ENOCOFFEE.  You could only kill it if you implement Jan's suggestion
> of not making older_than_this a pointer..

Yes. And that won't be a straightforward code refactor. It will have
very small side effects, so we'd better kill it in a standalone patch.

Thanks,
Fengguang
