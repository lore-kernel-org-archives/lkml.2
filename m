Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1IGQPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:15:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:37866 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab1IGQPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:15:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,344,1312182000"; 
   d="scan'208";a="46313017"
Date: Wed, 7 Sep 2011 17:06:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/18] writeback: charge leaked page dirties to active
 tasks
Message-ID: <20110907090615.GA13841@localhost>
References: <20110904015305.367445271@intel.com>
 <20110904020916.588150387@intel.com>
 <1315325796.14232.20.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315325796.14232.20.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 12:16:36AM +0800, Peter Zijlstra wrote:
> On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> > The solution is to charge the pages dirtied by the exited gcc to the
> > other random gcc/dd instances.
> 
> random dirtying task, seeing it lacks a !strcmp(t->comm, "gcc") || !
> strcmp(t->comm, "dd") clause.

OK.

> >  It sounds not perfect, however should
> > behave good enough in practice. 
> 
> Seeing as that throttled tasks aren't actually running so those that are
> running are more likely to pick it up and get throttled, therefore
> promoting an equal spread.. ?

Exactly. Let me write that into changelog :)

Thanks,
Fengguang
