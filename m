Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1IFQTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:19:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:43217 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1IFQTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:19:09 -0400
Subject: Re: [PATCH 17/18] writeback: fix dirtied pages accounting on redirty
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 06 Sep 2011 18:18:56 +0200
In-Reply-To: <20110904020916.841463184@intel.com>
References: <20110904015305.367445271@intel.com>
	 <20110904020916.841463184@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315325936.14232.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> De-account the accumulative dirty counters on page redirty.
> 
> Page redirties (very common in ext4) will introduce mismatch between
> counters (a) and (b)
> 
> a) NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied
> b) NR_WRITTEN, BDI_WRITTEN
> 
> This will introduce systematic errors in balanced_rate and result in
> dirty page position errors (ie. the dirty pages are no longer balanced
> around the global/bdi setpoints).
> 

So wtf is ext4 doing? Shouldn't a page stay dirty until its written out?

That is, should we really frob around this behaviour or fix ext4 because
its on crack?
