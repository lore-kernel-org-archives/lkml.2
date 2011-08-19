Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1HSO1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:27:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:45744 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab1HSO1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:27:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,251,1312182000"; 
   d="scan'208";a="40263416"
Date: Fri, 19 Aug 2011 22:27:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] writeback: Per-block device
 bdi->dirty_writeback_interval and bdi->dirty_expire_interval.
Message-ID: <20110819142705.GB15401@localhost>
References: <CAFPAmTSrh4r71eQqW-+_nS2KFK2S2RQvYBEpa3QnNkZBy8ncbw@mail.gmail.com>
 <20110818094824.GA25752@localhost>
 <1313669702.6607.24.camel@sauron>
 <20110818131343.GA17473@localhost>
 <1313754949.6607.52.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313754949.6607.52.camel@sauron>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 07:55:43PM +0800, Artem Bityutskiy wrote:
> On Thu, 2011-08-18 at 21:13 +0800, Wu Fengguang wrote:
> > Thinking twice about it, I find that the different requirements for
> > interval flash/external microSD can also be solved by this scheme.
> > 
> > Introduce a per-bdi dirty_background_time (and optionally dirty_time)
> > as the counterpart of (and works in parallel to) global dirty[_background]_ratio,
> > however with unit "milliseconds worth of data".
> > 
> > The per-bdi dirty_background_time will be set low for external microSD
> > and high for internal flash. Then you get timely writeouts for microSD
> > and reasonably delayed writes for internal flash (controllable by the
> > global dirty_expire_centisecs).
> > 
> > The dirty_background_time will actually work more reliable than
> > dirty_expire_centisecs because it will checked immediately after the
> > application dirties more pages. And the dirty_time could provide
> > strong data integrity guarantee -- much stronger than
> > dirty_expire_centisecs -- if used.
> > 
> > Does that sound reasonable?
> 
> Yes, this would probably work. But note, we do not have this problem
> anymore, I was just talking about the past experience, so I cannot
> validate any possible patch.

OK, thanks for the information. What do you mean by "not have this
problem any more"? Did you worked around it in other ways, such as
sync mount (which seems rather inefficient though)?

Thanks,
Fengguang
