Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1HKVAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:00:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab1HKVAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:00:32 -0400
Date: Thu, 11 Aug 2011 17:00:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] IO-less dirty throttling v8
Message-ID: <20110811210008.GI8552@redhat.com>
References: <20110806084447.388624428@intel.com>
 <20110809020127.GA3700@redhat.com>
 <20110811032143.GB11404@localhost>
 <20110811204255.GH8552@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110811204255.GH8552@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 04:42:55PM -0400, Vivek Goyal wrote:

[..]
> So I see following immediate extension of your scheme possible.
> 
> - Inherit ioprio from iocontext and provide buffered write service
>   differentiation for writers.
> 
> - Create a per task buffered write throttling interface and do
>   absolute throttling of task.
> 
> - We can possibly do the idea of throttling group wide buffered
>   writes only control at this layer using this mechanism.

Though personally I like the idea of absolute throttling at page cache
level as it can help a bit with problem of buffered WRITES impacting
the latency of everything else in the system. CFQ helps a lot but
it idles enough that cost of this isolation is very high on faster
storage.

Deadline and noop really do not do much about protection from WRITEs.

So it is not perfect but might prove to be good enough for some use
cases.

Thanks
Vivek
