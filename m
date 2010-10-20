Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab0JTEbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 00:31:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55379 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0JTEbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 00:31:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 20 Oct 2010 13:26:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 02/11] memcg: document cgroup dirty memory interfaces
Message-Id: <20101020132619.5867d71d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <xr93vd4xze0e.fsf@ninji.mtv.corp.google.com>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-3-git-send-email-gthelen@google.com>
	<20101019172744.45e0a8dc.nishimura@mxp.nes.nec.co.jp>
	<xr93lj5t5245.fsf@ninji.mtv.corp.google.com>
	<20101020091109.ccd7b39a.kamezawa.hiroyu@jp.fujitsu.com>
	<xr93r5fl1poc.fsf@ninji.mtv.corp.google.com>
	<20101020130654.bf861eda.kamezawa.hiroyu@jp.fujitsu.com>
	<xr93vd4xze0e.fsf@ninji.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 21:25:53 -0700
Greg Thelen <gthelen@google.com> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> 
> > On Tue, 19 Oct 2010 17:45:08 -0700
> > Greg Thelen <gthelen@google.com> wrote:
> >
> >> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> >> > BTW, how about supporing dirty_limit_in_bytes when use_hierarchy=0 or
> >> > leave it as broken when use_hierarchy=1 ?  It seems we can only
> >> > support dirty_ratio when hierarchy is used.
> >> 
> >> I am not sure what you mean here.
> >
> > When using dirty_ratio, we can check the value of dirty_ratio at setting it
> > and make guarantee that any children's dirty_ratio cannot exceeds it parent's.
> >
> > If we guarantee that, we can keep dirty_ratio even under hierarchy.
> >
> > When it comes to dirty_limit_in_bytes, we never able to do such kind of
> > controls. So, it will be broken and will do different behavior than
> > dirty_ratio.
> 
> I think that for use_hierarchy=1, we could support either dirty_ratio or
> dirty_limit_in_bytes.  The code that modifies dirty_limit_in_bytes could
> ensure that the sum the dirty_limit_in_bytes of each child does not
> exceed the parent's dirty_limit_in_bytes.
> 
But the sum of all children's dirty_bytes can exceeds. (Adding check code
will be messy at this stage. Maybe in TODO list)

> > So, not supporing dirty_bytes when use_hierarchy==1 for now sounds
> > reasonable to me.
> 
> Ok, I will add the use_hierarchy==1 check and repost the patches.
> 
> I will wait to post the -v4 patch series until you post an improved
> "[PATCH][memcg+dirtylimit] Fix overwriting global vm dirty limit setting
> by memcg (Re: [PATCH v3 00/11] memcg: per cgroup dirty page accounting"
> patch.  I think it makes sense to integrate that into -v4 of the series.
> 

yes...but I'm now wondering how "FreePages" of memcg should be handled...

Considering only dirtyable pages may make sense but it's different behavior
than global's one and the user will see the limitation of effects even when
they use only small pages. I'd like to consider this, too.

Thanks,
-Kame


