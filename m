Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1CODBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 23:01:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32845 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1CODB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 23:01:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Mar 2011 11:54:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v6 0/9] memcg: per cgroup dirty page accounting
Message-Id: <20110315115451.7a7d3605.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTineM7M1R6fVFJe0ax-DN=_Rnb+7Cmk5HTH0D+Na@mail.gmail.com>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
	<20110311171006.ec0d9c37.akpm@linux-foundation.org>
	<AANLkTimT-kRMQW3JKcJAZP4oD3EXuE-Bk3dqumH_10Oe@mail.gmail.com>
	<20110315105612.f600a659.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTineM7M1R6fVFJe0ax-DN=_Rnb+7Cmk5HTH0D+Na@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 19:51:22 -0700
Greg Thelen <gthelen@google.com> wrote:

> On Mon, Mar 14, 2011 at 6:56 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Mon, 14 Mar 2011 11:29:17 -0700
> > Greg Thelen <gthelen@google.com> wrote:
> >
> >> On Fri, Mar 11, 2011 at 5:10 PM, Andrew Morton
> The foreign dirtier issue is all about identifying the memcg (or
> possibly multiple bdi) that need balancing.    If the foreign dirtier
> issue is not important then we can focus on identifying inodes to
> writeback that will lower the current's memcg dirty usage.  I am fine
> ignoring the foreign dirtier issue for now and breaking the problem
> into smaller pieces.
> 
ok.

> I think this can be done with out any additional state.  Can just scan
> the memcg lru to find dirty file pages and thus inodes to pass to
> sync_inode(), or some other per-inode writeback routine?
> 

I think it works, finding inodes to be cleaned by LRU scanning.

Thanks,
-Kame

