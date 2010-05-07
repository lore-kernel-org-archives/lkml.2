Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab0EGBLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 21:11:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38054 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab0EGBLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 21:11:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 7 May 2010 10:07:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, balbir@linux.vnet.ibm.com,
       nishimura@mxp.nes.nec.co.jp, kirill@shutemov.name, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] mm: memcontrol - uninitialised return value
Message-Id: <20100507100729.a6589d8a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100506142417.6d317068.akpm@linux-foundation.org>
References: <1273058509-16625-1-git-send-email-ext-phil.2.carmody@nokia.com>
	<1273058509-16625-2-git-send-email-ext-phil.2.carmody@nokia.com>
	<20100506142417.6d317068.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010 14:24:17 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed,  5 May 2010 14:21:49 +0300
> Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:
> 
> > From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> > 
> > Only an out of memory error will cause ret to be set.
> > 
> > Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
> > Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> > ---
> >  mm/memcontrol.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 90e32b2..09af773 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3464,7 +3464,7 @@ static int mem_cgroup_unregister_event(struct cgroup *cgrp, struct cftype *cft,
> >  	int type = MEMFILE_TYPE(cft->private);
> >  	u64 usage;
> >  	int size = 0;
> > -	int i, j, ret;
> > +	int i, j, ret = 0;
> >  
> >  	mutex_lock(&memcg->thresholds_lock);
> >  	if (type == _MEM)
> 
> afacit the return value of cftype.unregister_event() is always ignored
> anyway.  Perhaps it should be changed to void-returning, or fixed.
> 
> 
Ah, it's now "TODO". But hmm...."unregister_event()" is called by workqueue.
(for avoiding race?)

I think unregister_event should be "void" and mem_cgroup_unregister_event()
should be implemented as "never fail" function.

I'll try by myself....but if someone knows this event notifier implementation well,
please.

Thanks,
-Kame

