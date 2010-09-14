Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0INElK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:41:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57313 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0INElH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:41:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Sep 2010 13:35:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [BUGFIX][PATCH] memcg: fix race in file_mapped accouting flag
 management
Message-Id: <20100914133546.35d90726.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100913140803.b83d3fe1.akpm@linux-foundation.org>
References: <20100913160822.0c2cd732.kamezawa.hiroyu@jp.fujitsu.com>
	<20100913140803.b83d3fe1.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 14:08:03 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 13 Sep 2010 16:08:22 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
<snip>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/memcontrol.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: lockless-update/mm/memcontrol.c
> > ===================================================================
> > --- lockless-update.orig/mm/memcontrol.c
> > +++ lockless-update/mm/memcontrol.c
> > @@ -1485,7 +1485,8 @@ void mem_cgroup_update_file_mapped(struc
> >  		SetPageCgroupFileMapped(pc);
> >  	} else {
> >  		__this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
> > -		ClearPageCgroupFileMapped(pc);
> > +		if (page_mapped(page)) /* for race between dec->inc counter */
> > +			ClearPageCgroupFileMapped(pc);
> >  	}
> 
> This should be !page_mapped(), shouldn't it?
> 

Ahhhh, yes. reflesh miss..

> And your second patch _does_ have !page_mapped() here, which is why the
> second patch didn't apply.
> 
Very sorry.

> I tried to fix things up.  Please check.

Thank you. 

-Kame

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

