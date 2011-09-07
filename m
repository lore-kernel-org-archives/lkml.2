Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1IGAWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 20:22:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab1IGAWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 20:22:23 -0400
Date: Wed, 7 Sep 2011 02:22:22 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/18] writeback: fix dirtied pages accounting on
 redirty
Message-ID: <20110907002222.GF31945@quack.suse.cz>
References: <20110904015305.367445271@intel.com>
 <20110904020916.841463184@intel.com>
 <1315325936.14232.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315325936.14232.22.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-09-11 18:18:56, Peter Zijlstra wrote:
> On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> > De-account the accumulative dirty counters on page redirty.
> > 
> > Page redirties (very common in ext4) will introduce mismatch between
> > counters (a) and (b)
> > 
> > a) NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied
> > b) NR_WRITTEN, BDI_WRITTEN
> > 
> > This will introduce systematic errors in balanced_rate and result in
> > dirty page position errors (ie. the dirty pages are no longer balanced
> > around the global/bdi setpoints).
> > 
> 
> So wtf is ext4 doing? Shouldn't a page stay dirty until its written out?
> 
> That is, should we really frob around this behaviour or fix ext4 because
> its on crack?
  Fengguang, could you please verify your findings with recent kernel? I
believe ext4 got fixed in this regard some time ago already (and yes, old
delalloc writeback code in ext4 was terrible).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
