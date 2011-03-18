Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1CROrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:47:39 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:38765 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1CROrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:47:33 -0400
Date: Fri, 18 Mar 2011 15:46:51 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>,
        Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH v6 0/9] memcg: per cgroup dirty page accounting
Message-ID: <20110318144651.GW2140@cmpxchg.org>
References: <AANLkTimT-kRMQW3JKcJAZP4oD3EXuE-Bk3dqumH_10Oe@mail.gmail.com>
 <20110314202324.GG31120@redhat.com>
 <AANLkTinDNOLMdU7EEMPFkC_f9edCx7ZFc7=qLRNAEmBM@mail.gmail.com>
 <20110315184839.GB5740@redhat.com>
 <20110316131324.GM2140@cmpxchg.org>
 <AANLkTim7q3cLGjxnyBS7SDdpJsGi-z34bpPT=MJSka+C@mail.gmail.com>
 <20110316215214.GO2140@cmpxchg.org>
 <AANLkTinCErw+0QGpXJ4+JyZ1O96BC7SJAyXaP4t5v17c@mail.gmail.com>
 <20110317124350.GQ2140@cmpxchg.org>
 <20110318142949.GA19859@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318142949.GA19859@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 10:29:50AM -0400, Vivek Goyal wrote:
> On Thu, Mar 17, 2011 at 01:43:50PM +0100, Johannes Weiner wrote:
> 
> [..]
> > So structures roughly like this:
> > 
> > struct mem_cgroup {
> > 	...
> > 	/* key is struct backing_dev_info * */
> > 	struct rb_root memcg_bdis;
> > };
> > 
> > struct memcg_bdi {
> > 	/* key is struct address_space * */
> > 	struct rb_root memcg_mappings;
> > 	struct rb_node node;
> > };
> > 
> > struct memcg_mapping {
> > 	struct address_space *mapping;
> > 	struct mem_cgroup *memcg;
> > 	struct rb_node node;
> > 	atomic_t count;
> > };
> > 
> > struct page_cgroup {
> > 	...
> > 	struct memcg_mapping *memcg_mapping;
> > };
> 
> Johannes, didn't you want page->mapping to point to memcg_mapping instead
> of increasing the size of page_cgroup?

Initially, yes, but this is far less invasive.  We don't increase
page_cgroup, though: memcg_mapping contains the pointer to struct
mem_cgroup, it can replace pc->memcg for now.
