Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0KXM5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:57:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:53161 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab0KXM5D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:57:03 -0500
Subject: Re: [PATCH 09/13] writeback: reduce per-bdi dirty threshold ramp
 up time
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101124123923.GB10413@localhost>
References: <20101117042720.033773013@intel.com>
	 <20101117042850.361893350@intel.com> <1290597341.2072.456.camel@laptop>
	 <20101124123923.GB10413@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 13:56:40 +0100
Message-ID: <1290603400.2072.466.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 20:39 +0800, Wu Fengguang wrote:
> > > @@ -125,7 +125,7 @@ static int calc_period_shift(void)
> > >     else
> > >             dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
> > >                             100;
> > > -   return 2 + ilog2(dirty_total - 1);
> > > +   return ilog2(dirty_total - 1) - 1;
> > >  }
> > >  
> > >  /*
> > 
> > You could actually improve upon this now that you have per-bdi bandwidth
> > estimations, simply set the period to (seconds * bandwidth) to get
> > convergence in @seconds.
> 
> I'd like to, but there is the global vs. bdi discrepancy to be
> addressed first :)
> 
> How about doing this simple fix first, and then revisit doing per-bdi
> vm_dirties after the bandwidth estimation goes upstream? 

Sure
