Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1INHlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 03:41:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35514 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1INHlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 03:41:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Sep 2011 16:40:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 04/11] mm: memcg: per-priority per-zone hierarchy scan
 generations
Message-Id: <20110914164045.f8074468.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110914055634.GA28051@redhat.com>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
	<1315825048-3437-5-git-send-email-jweiner@redhat.com>
	<20110913192759.ff0da031.kamezawa.hiroyu@jp.fujitsu.com>
	<20110913110301.GB18886@redhat.com>
	<20110914095504.30fca5d0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110914055634.GA28051@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011 07:56:34 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Wed, Sep 14, 2011 at 09:55:04AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Tue, 13 Sep 2011 13:03:01 +0200
> > Johannes Weiner <jweiner@redhat.com> wrote:
> No, the hierarchy iteration in shrink_zone() is done after a single
> memcg, which is equivalent to the old code: scan all zones at all
> priority levels from a memcg, then move on to the next memcg.  This
> also works because of the per-zone per-priority last_scanned_child:
> 
> 	for each priority
> 	  for each zone
> 	    mem = mem_cgroup_iter(root)
> 	    scan(mem)
> 
> priority-12 + zone-1 will yield memcg-1.  priority-12 + zone-2 starts
> at its own last_scanned_child, so yields memcg-1 as well, etc.  A
> second reclaimer that comes in with priority-12 + zone-1 will receive
> memcg-2 for scanning.  So there is no change in behaviour for limit
> reclaim.
> 
ok, thanks.

> > If so, I need to abandon node-selection-logic for reclaim-by-limit
> > and nodemask-for-memcg which shows me very good result. 
> > I'll be sad ;)
> 
> With my clarification, do you still think so?
> 

No. Thank you. 

Regards,
-Kame

