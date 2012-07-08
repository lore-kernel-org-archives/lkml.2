Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2GHXBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:01:16 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53695 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab2GHXBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:01:15 -0400
Date: Mon, 9 Jul 2012 01:01:00 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Sha Zhengju <handai.szj@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
Message-ID: <20120708230100.GA5340@cmpxchg.org>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
 <1340881525-5835-1-git-send-email-handai.szj@taobao.com>
 <4FF291BE.7030509@jp.fujitsu.com>
 <20120708144459.GA18272@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120708144459.GA18272@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2012 at 10:44:59PM +0800, Fengguang Wu wrote:
> On Tue, Jul 03, 2012 at 03:31:26PM +0900, KAMEZAWA Hiroyuki wrote:
> > (2012/06/28 20:05), Sha Zhengju wrote:
> > > From: Sha Zhengju <handai.szj@taobao.com>
> > > 
> > > Similar to dirty page, we add per cgroup writeback pages accounting. The lock
> > > rule still is:
> > > 	mem_cgroup_begin_update_page_stat()
> > > 	modify page WRITEBACK stat
> > > 	mem_cgroup_update_page_stat()
> > > 	mem_cgroup_end_update_page_stat()
> > > 
> > > There're two writeback interface to modify: test_clear/set_page_writeback.
> > > 
> > > Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> > 
> > Seems good to me. BTW, you named macros as MEM_CGROUP_STAT_FILE_XXX
> > but I wonder these counters will be used for accounting swap-out's dirty pages..
> > 
> > STAT_DIRTY, STAT_WRITEBACK ? do you have better name ?
> 
> Perhaps we can follow the established "enum zone_stat_item" names:
> 
>         NR_FILE_DIRTY,
>         NR_WRITEBACK,
> 
> s/NR_/MEM_CGROUP_STAT_/
> 
> The names indicate that dirty pages for anonymous pages are not
> accounted (by __set_page_dirty_no_writeback()). While the writeback
> pages accounting include both the file/anon pages.
> 
> Ah then we'll need to update the document in patch 0 accordingly. This
> may sound a bit tricky to the users..

We already report the global one as "nr_dirty", though.  Please don't
give the memcg one a different name.

The enum naming is not too critical, but it would be nice to have it
match the public name.
