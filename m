Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3ADChm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 21:37:42 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59113 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab3ADChk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 21:37:40 -0500
X-AuditID: 9c930179-b7becae000000e51-fa-50e64071fa83
Date: Fri, 4 Jan 2013 11:37:37 +0900
From: Minchan Kim <minchan@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Arun Sharma <asharma@fb.com>, sanjay@google.com,
        Paul Turner <pjt@google.com>, David Rientjes <rientjes@google.com>,
        John Stultz <john.stultz@linaro.org>, Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [RFC v4 0/3] Support volatile for anonymous range
Message-ID: <20130104023737.GA2617@blaptop>
References: <1355813274-571-1-git-send-email-minchan@kernel.org>
 <50DA62CE.30604@jp.fujitsu.com>
 <20121226034600.GB2453@blaptop>
 <50DCE6D5.7000901@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50DCE6D5.7000901@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 09:24:53AM +0900, Kamezawa Hiroyuki wrote:
> (2012/12/26 12:46), Minchan Kim wrote:
> >Hi Kame,
> >
> >What are you doing these holiday season? :)
> >I can't believe you sit down in front of computer.
> >
> Honestly, my holiday starts tomorrow ;) (but until 1/5 in the next year.)
> 
> >>
> >>Hm, by the way, the user need to attach pages to the process by causing page-fault
> >>(as you do by memset()) before calling mvolatile() ?
> >
> >For effectiveness, Yes.
> >
> 
> Isn't it better to make page-fault by get_user_pages() in mvolatile() ?
> Calling page fault in userland seems just to increase burden of apps.

It seems you misunderstood. Firstly, this patch's goal is to minimize
minor fault + page allocation + memset_zero if possible on anon pages.

If someone(like allocator) calls madvise(DONTNEED)/munmap on range
which has garbage collected memory, VM zaps all the pte so if user
try to reuse that range, we can't avoid above overheads.

The mvolatile avoids them with not zapping ptes when memory pressure isn't
severe while VM can discard pages without swapping out if memory pressure
happens.

So, GUP in mvolatile isn't necessary.

> 
> >>
> >>I think your approach is interesting, anyway.
> >
> >Thanks for your interest, Kame.
> >
> >あけましておめでとう.
> >
> 
> A happy new year.
> 
> Thanks,
> -Kame
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
