Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab1HWQzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:55:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1HWQzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:55:03 -0400
Date: Tue, 23 Aug 2011 18:54:53 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] thp: tail page refcounting fix
Message-ID: <20110823165453.GB23870@redhat.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
 <20110822213347.GF2507@redhat.com>
 <20110823164515.GA2653@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823164515.GA2653@barrios-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 01:45:15AM +0900, Minchan Kim wrote:
> Nice idea!

Thanks! It felt natural to account the tail refcounts in
page_tail->_count, so they were already there and it was enough to add
the page_mapcount(head_page) to the page_tail->_count. But there's no
particular reason we had to do the tail_page refcounting in the
->_page field before the split...

> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> The code looks good to me.

Thanks a lot for the quick review.

> The nitpick is about naming 'foll'.
> What does it mean? 'follow'?
> If it is, I hope we use full name.
> Regardless of renaming it, I am okay the patch.

Ok the name comes from FOLL_GET. Only code  paths marked by checking
FOLL_GET are allowed to call get_page_foll(). Anything else can't.

mm/*memory.c:

	 if (flags & FOLL_GET)
	    get_page_foll(page);
