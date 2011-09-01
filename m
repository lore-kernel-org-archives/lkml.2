Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1IAARH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 20:17:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58560 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab1IAARF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 20:17:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Sep 2011 09:09:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: skip scanning active lists based on individual
 size
Message-Id: <20110901090931.c0721216.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAEwNFnBSg71QoLZbOqZbXK3fGEGneituU3PmiYTAw1VM3KcwcQ@mail.gmail.com>
References: <20110831090850.GA27345@redhat.com>
	<CAEwNFnBSg71QoLZbOqZbXK3fGEGneituU3PmiYTAw1VM3KcwcQ@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 19:13:34 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Wed, Aug 31, 2011 at 6:08 PM, Johannes Weiner <jweiner@redhat.com> wrote:
> > Reclaim decides to skip scanning an active list when the corresponding
> > inactive list is above a certain size in comparison to leave the
> > assumed working set alone while there are still enough reclaim
> > candidates around.
> >
> > The memcg implementation of comparing those lists instead reports
> > whether the whole memcg is low on the requested type of inactive
> > pages, considering all nodes and zones.
> >
> > This can lead to an oversized active list not being scanned because of
> > the state of the other lists in the memcg, as well as an active list
> > being scanned while its corresponding inactive list has enough pages.
> >
> > Not only is this wrong, it's also a scalability hazard, because the
> > global memory state over all nodes and zones has to be gathered for
> > each memcg and zone scanned.
> >
> > Make these calculations purely based on the size of the two LRU lists
> > that are actually affected by the outcome of the decision.
> >
> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > Cc: Balbir Singh <bsingharora@gmail.com>
> 
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> I can't understand why memcg is designed for considering all nodes and zones.
> Is it a mistake or on purpose?

It's purpose. memcg just takes care of the amount of pages.
Them, any performance numbers ?


But, hmm, this change may be good for softlimit and your work.

I'll ack when you add performance numbers in changelog.

Thanks,
-Kame

