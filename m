Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab1FGXDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:03:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753982Ab1FGXDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:03:19 -0400
Date: Tue, 7 Jun 2011 16:02:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/15] writeback: introduce .tagged_writepages for the
 WB_SYNC_NONE sync stage
Message-Id: <20110607160234.53de9f93.akpm@linux-foundation.org>
In-Reply-To: <20110607213853.513366237@intel.com>
References: <20110607213236.634026193@intel.com>
	<20110607213853.513366237@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jun 2011 05:32:37 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
> WB_SYNC_ALL sync. Identify the first stage with .tagged_writepages and
> do livelock prevention for it, too.
> 
> Note that writeback_inodes_sb() is called by not only sync(), they are
> treated the same because the other callers also need livelock prevention.
> 
> Impact:  It changes the order in which pages/inodes are synced to disk.
> Now in the WB_SYNC_NONE stage, it won't proceed to write the next inode
> until finished with the current inode.

What problem is this patch actually fixing?  It sounds like there's
some livelock scenario in the WB_SYNC_NONE phase.  otoh the final
paragraph implies that the WB_SYNC_NONE phase is failing to write some
pages under some situations.

Suggest that the changelog be fleshed out to cover all of this.
