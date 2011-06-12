Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1FLPer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 11:34:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:9047 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab1FLPem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 11:34:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,355,1304319600"; 
   d="scan'208";a="12597404"
Message-Id: <20110612151821.601514494@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Jun 2011 23:18:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] bdi write bandwidth estimation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Do bdi write bandwidth estimation in the flusher thread at 200ms intervals,
and in case the flusher is blocked syncing large files, the throttled dirtier
tasks will back it up.

To get an idea of the adaption speed and fluctuation range, here are
some real examples (check the red dots and the yellow line):

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/xfs-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.21:51/balance_dirty_pages-bandwidth.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/ext3-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.22:02/balance_dirty_pages-bandwidth.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/ext4-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.21:57/balance_dirty_pages-bandwidth.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/btrfs-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.22:07/balance_dirty_pages-bandwidth.png

The old version outputs, for your reference:

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/4G-60%25/ext3-1dd-1M-8p-3911M-60%25-2.6.38-rc5-dt6+-2011-02-22-11-51/balance_dirty_pages-bandwidth.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/4G-60%25/xfs-1dd-1M-8p-3911M-60%25-2.6.38-rc5-dt6+-2011-02-22-11-10/balance_dirty_pages-bandwidth.png
http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/NFS/nfs-1dd-1M-8p-2945M-20%25-2.6.38-rc6-dt6+-2011-02-22-21-09/balance_dirty_pages-bandwidth.png

This is merely the estimation part. The in-kernel users of the estimated
bandwidth will follow in the coming series.

Thanks,
Fengguang

