Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1KWGlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:41:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39872 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758631Ab1KWGlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:41:18 -0500
Date: Wed, 23 Nov 2011 15:41:11 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmscan: add task name to warn_scan_unevictable() messages
Message-ID: <20111123064111.GB25067@barrios-laptop.redhat.com>
References: <1322027721-23677-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
 <20111123062405.GA25067@barrios-laptop.redhat.com>
 <alpine.DEB.2.00.1111222230270.21009@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111222230270.21009@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:32:45PM -0800, David Rientjes wrote:
> On Wed, 23 Nov 2011, Minchan Kim wrote:
> 
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index a1893c0..29d163e 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -3448,9 +3448,10 @@ void scan_mapping_unevictable_pages(struct address_space *mapping)
> > >  static void warn_scan_unevictable_pages(void)
> > >  {
> > >  	printk_once(KERN_WARNING
> > > -		    "The scan_unevictable_pages sysctl/node-interface has been "
> > > +		    "%s: The scan_unevictable_pages sysctl/node-interface has been "
> > >  		    "disabled for lack of a legitimate use case.  If you have "
> > > -		    "one, please send an email to linux-mm@kvack.org.\n");
> > > +		    "one, please send an email to linux-mm@kvack.org.\n",
> > > +		    current->comm);
> > >  }
> > 
> > Just nitpick:
> > How about using WARN_ONCE instead of custom warning?
> > It can show more exact call path as well as comm.
> > I guess it's more noticible to users.
> > Anyway, either is okay to me.
> > 
> 
> When I used WARN_ONCE() to notify users that /proc/pid/oom_adj was 
> deprecated, people complained that it triggered userspace log parsers 
> thinking that there's a serious problem and it adds a taint flag so it got 
> reverted.  I'd recommend keeping it printk_once().

printk_once is better in case of not serious WARNING
once I listen your opinion.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
