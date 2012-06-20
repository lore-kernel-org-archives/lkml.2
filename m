Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2FTJzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:55:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:59948 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab2FTJzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="155928998"
Date: Wed, 20 Jun 2012 17:55:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Ying Han <yinghan@google.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm] memcg: prevent from OOM with too many dirty pages
Message-ID: <20120620095546.GB8765@localhost>
References: <1340117404-30348-1-git-send-email-mhocko@suse.cz>
 <20120619150014.1ebc108c.akpm@linux-foundation.org>
 <20120620092011.GB4011@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620092011.GB4011@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Finally, I wonder if there should be some timeout of that wait.  I
> > don't know why, but I wouldn't be surprised if we hit some glitch which
> > causes us to add one!
> > 
> 
> If we hit such a situation it means that flush is no longer working which
> is interesting in itself. I guess one possibility where it can occur is
> if we hit global dirty limits (or memcg dirty limits when they exist)
> and the page is backed by NFS that is disconnected. That would stall here
> potentially forever but it's already the case that a system that hits its
> dirty limits with a disconnected NFS is in trouble and a timeout here will
> not do much to help.

Agreed. I've run into such cases and cannot login even locally because
the shell will be blocked trying to write even 1 byte at startup time. 
Any opened shells are also stalled on writing to .bash_history etc.

Thanks,
Fengguang
