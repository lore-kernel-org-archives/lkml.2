Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2CIJvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:51:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab2CIJvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:51:38 -0500
Date: Fri, 9 Mar 2012 10:51:35 +0100
From: Jan Kara <jack@suse.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 5/9] writeback: introduce the pageout work
Message-ID: <20120309095135.GC21038@quack.suse.cz>
References: <20120228160403.9c9fa4dc.akpm@linux-foundation.org>
 <20120301123640.GA30369@localhost>
 <20120301163837.GA13104@quack.suse.cz>
 <20120302044858.GA14802@localhost>
 <20120302095910.GB1744@quack.suse.cz>
 <20120302103951.GA13378@localhost>
 <20120302115700.7d970497.akpm@linux-foundation.org>
 <20120303135558.GA9869@localhost>
 <1331135301.32316.29.camel@sauron.fi.intel.com>
 <20120309073113.GA5337@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309073113.GA5337@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Thu 08-03-12 23:31:13, Wu Fengguang wrote:
> On Wed, Mar 07, 2012 at 05:48:21PM +0200, Artem Bityutskiy wrote:
> > On Sat, 2012-03-03 at 21:55 +0800, Fengguang Wu wrote:
> > >   13   1125  /c/linux/fs/ubifs/file.c <<do_truncation>>   <===== deadlockable
> > 
> > Sorry, but could you please explain once again how the deadlock may
> > happen?
> 
> Sorry I confused ubifs do_truncation() with the truncate_inode_pages()
> that may be called from iput().
> 
> The once suspected deadlock scheme is when the flusher thread calls
> the final iput:
> 
>         flusher thread
>           iput_final
>             <some ubifs function>
>               ubifs_budget_space
>                 shrink_liability
>                   writeback_inodes_sb
>                     writeback_inodes_sb_nr
>                       bdi_queue_work
>                       wait_for_completion  => end up waiting for the flusher itself
> 
> However I cannot find any ubifs functions to form the above loop, so
> ubifs should be safe for now.
  Yeah, me neither but I also failed to find a place where
ubifs_evict_inode() truncates inode space when deleting the inode... Artem?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
