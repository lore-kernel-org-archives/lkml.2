Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965597Ab2B1PVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:21:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:3577 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965500Ab2B1PVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:21:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112233446"
Date: Tue, 28 Feb 2012 23:15:50 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] memcg: dirty page accounting support routines
Message-ID: <20120228151550.GA5490@localhost>
References: <20120228140022.614718843@intel.com>
 <20120228144747.124608935@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228144747.124608935@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:00:26PM +0800, Fengguang Wu wrote:
> From: Greg Thelen <gthelen@google.com>
> 
> Added memcg dirty page accounting support routines.  These routines are
> used by later changes to provide memcg aware writeback and dirty page
> limiting.  A mem_cgroup_dirty_info() tracepoint is is also included to
> allow for easier understanding of memcg writeback operation.

Greg, sorry that the mem_cgroup_dirty_info() interfaces and
tracepoints are abridged since they are not used here. Obviously this
patch series is not enough to keep the number of dirty pages under
control. It only tries to improve page reclaim behavior given whatever
dirty number. We'll need further schemes to keep dirty pages under
sane levels, so that unrelated tasks do not suffer from reclaim waits
when there are heavy writers in the same memcg.

Thanks,
Fengguang
