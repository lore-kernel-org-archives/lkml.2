Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab2CANkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:40:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:34747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab2CANke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:40:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113291984"
Date: Thu, 1 Mar 2012 21:35:20 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/9] writeback: introduce the pageout work
Message-ID: <20120301133520.GA7202@localhost>
References: <20120228140022.614718843@intel.com>
 <20120228144747.198713792@intel.com>
 <20120229135156.GA31106@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229135156.GA31106@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However the other type of works, if ever they come, can still block us
> for long time. Will need a proper way to guarantee fairness.

The simplistic way around this may be to refuse to queue new pageout
works when found other type of works in the queue. Then vmscan will
fall back to pageout(). It's rare condition anyway and hardly deserves
a comprehensive fairness scheme.

Thanks,
Fengguang
