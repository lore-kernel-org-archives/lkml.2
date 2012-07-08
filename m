Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2GHOpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 10:45:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:6782 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab2GHOpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 10:45:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174727073"
Date: Sun, 8 Jul 2012 22:45:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Sha Zhengju <handai.szj@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 5/7] memcg: add per cgroup dirty pages accounting
Message-ID: <20120708144538.GB18272@localhost>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
 <1340881486-5770-1-git-send-email-handai.szj@taobao.com>
 <4FF289B4.3060706@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF289B4.3060706@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 02:57:08PM +0900, KAMEZAWA Hiroyuki wrote:
> (2012/06/28 20:04), Sha Zhengju wrote:
> > From: Sha Zhengju <handai.szj@taobao.com>
> > 
> > This patch adds memcg routines to count dirty pages, which allows memory controller
> > to maintain an accurate view of the amount of its dirty memory and can provide some
> > info for users while group's direct reclaim is working.
> > 
> > After Kame's commit 89c06bd5(memcg: use new logic for page stat accounting), we can
> > use 'struct page' flag to test page state instead of per page_cgroup flag. But memcg
> > has a feature to move a page from a cgroup to another one and may have race between
> > "move" and "page stat accounting". So in order to avoid the race we have designed a
> > bigger lock:
> > 
> >           mem_cgroup_begin_update_page_stat()
> >           modify page information	-->(a)
> >           mem_cgroup_update_page_stat()  -->(b)
> >           mem_cgroup_end_update_page_stat()
> > 
> > It requires (a) and (b)(dirty pages accounting) can stay close enough.
> > 
> > In the previous two prepare patches, we have reworked the vfs set page dirty routines
> > and now the interfaces are more explicit:
> > 	incrementing (2):
> > 		__set_page_dirty
> > 		__set_page_dirty_nobuffers
> > 	decrementing (2):
> > 		clear_page_dirty_for_io
> > 		cancel_dirty_page
> > 
> > 
> > Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> 
> Thank you. This seems much cleaner than expected ! very good.
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>

I have the same good feelings :)

Acked-by: Fengguang Wu <fengguang.wu@intel.com>

