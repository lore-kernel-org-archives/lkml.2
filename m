Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1IGQqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:46:24 -0400
Received: from verein.lst.de ([213.95.11.211]:39150 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab1IGQqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:46:21 -0400
Date: Wed, 7 Sep 2011 18:46:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Christoph Hellwig <hch@lst.de>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/18] writeback: fix dirtied pages accounting on
	redirty
Message-ID: <20110907164619.GA10593@lst.de>
References: <20110904015305.367445271@intel.com> <20110904020916.841463184@intel.com> <1315325936.14232.22.camel@twins> <20110907002222.GF31945@quack.suse.cz> <20110907065635.GA12619@lst.de> <1315383587.11101.18.camel@twins> <20110907164216.GA7725@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907164216.GA7725@quack.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 06:42:16PM +0200, Jan Kara wrote:
>   Well, it depends on what you call common - usually, ->writepage is called
> from kswapd which shouldn't be common compared to writeback from a flusher
> thread. But now I've realized that JBD2 also calls ->writepage to fulfill
> data=ordered mode guarantees and that's what causes most of redirtying of
> pages on ext4. That's going away eventually but it will take some time. So
> for now writeback has to handle redirtying...

Under the "right" loads it may also happen for xfs because we can't
take lock non-blockingly in the fluser thread for example.

