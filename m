Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1CAEL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 23:11:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38313 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1CAEL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 23:11:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n3kokAQ1nzS70jZKLgcPsYZBiew51cB2fhVX9nYYFUe/7ccJwR0V2eWBlpV3rFQjbx
         v33qt8aPiRK6sb6W1CJnQWVWxpIPxLChOgueqmNH0kxbMk1ANIgV+5pTu6E5VIH/M0c9
         YkMEsQdA1bW0you8Kj2uTKZBpB+fgSdaG5D7o=
Date: Tue, 1 Mar 2011 13:11:46 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: compaction: Minimise the time IRQs are
 disabled while isolating pages for migration
Message-ID: <20110301041146.GA2107@barrios-desktop>
References: <1298664299-10270-1-git-send-email-mel@csn.ul.ie>
 <1298664299-10270-3-git-send-email-mel@csn.ul.ie>
 <20110228111746.34f3f3e0.kamezawa.hiroyu@jp.fujitsu.com>
 <20110228054818.GF22700@random.random>
 <20110228145402.65e6f200.kamezawa.hiroyu@jp.fujitsu.com>
 <20110228092814.GC9548@csn.ul.ie>
 <20110228184230.7c2eefb7.kamezawa.hiroyu@jp.fujitsu.com>
 <20110228101827.GE9548@csn.ul.ie>
 <20110301084209.2cfbd063.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301084209.2cfbd063.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 08:42:09AM +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 28 Feb 2011 10:18:27 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > > BTW, can't we drop disable_irq() from all lru_lock related codes ?
> > > 
> > 
> > I don't think so - at least not right now. Some LRU operations such as LRU
> > pagevec draining are run from IPI which is running from an interrupt so
> > minimally spin_lock_irq is necessary.
> > 
> 
> pagevec draining is done by workqueue(schedule_on_each_cpu()). 
> I think only racy case is just lru rotation after writeback.

put_page still need irq disable.


> 
> Thanks,
> -Kame
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
