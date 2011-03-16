Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1CPRHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:07:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1CPRHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:07:42 -0400
Date: Wed, 16 Mar 2011 13:06:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>,
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
        Justin TerAvest <teravest@google.com>
Subject: Re: [PATCH v6 0/9] memcg: per cgroup dirty page accounting
Message-ID: <20110316170612.GB13562@redhat.com>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
 <20110311171006.ec0d9c37.akpm@linux-foundation.org>
 <AANLkTimT-kRMQW3JKcJAZP4oD3EXuE-Bk3dqumH_10Oe@mail.gmail.com>
 <20110314202324.GG31120@redhat.com>
 <AANLkTinDNOLMdU7EEMPFkC_f9edCx7ZFc7=qLRNAEmBM@mail.gmail.com>
 <20110315184839.GB5740@redhat.com>
 <20110316131324.GM2140@cmpxchg.org>
 <20110316145959.GA13562@redhat.com>
 <20110316163510.GN2140@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110316163510.GN2140@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 05:35:10PM +0100, Johannes Weiner wrote:

[..]
> > IIUC, this sounds more like a solution to quickly come up with a list of
> > inodes one should be writting back. One could also come up with this kind of
> > list by going through memcg->lru list also (approximate). So this can be
> > an improvement over going through memcg->lru instead go through
> > memcg->mapping_list.
> 
> Well, if you operate on a large file it may make a difference between
> taking five inodes off the list and crawling through hundreds of
> thousands of pages to get to those same five inodes.
> 
> And having efficient inode lookup for a memcg makes targetted
> background writeback more feasible: pass the memcg in the background
> writeback work and have the flusher go through memcg->mappings,
> selecting those that match the bdi.
> 
> Am I missing something?  I feel like I missed your point.

No. Thanks for the explanation. I get it. Walking through the memcg->lru
list to figure out inodes memcg is writting to will be slow and can be
very painful for large files. Keeping a more direct mapping like
memcg_mapping list per memcg can simplify it a lot.

Thanks
Vivek 
