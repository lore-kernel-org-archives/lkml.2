Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1I1SFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:05:12 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59979 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab1I1SFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:05:11 -0400
Date: Thu, 29 Sep 2011 03:05:03 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH] vmscan: add barrier to prevent evictable page in
 unevictable list
Message-ID: <20110928180503.GC1696@barrios-desktop>
References: <1317174330-2677-1-git-send-email-minchan.kim@gmail.com>
 <CAF1ivSaf8ER9yDWohudy-huiq5QHS8vE04R+4+nPTQihZ2MAmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1ivSaf8ER9yDWohudy-huiq5QHS8vE04R+4+nPTQihZ2MAmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:04:05PM +0800, Lin Ming wrote:
> On Wed, Sep 28, 2011 at 9:45 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> > When racing between putback_lru_page and shmem_unlock happens,
> 
> s/shmem_unlock/shmem_lock/

I did it intentionally for represent shmem_lock with user = 1, lock = 0.
If you think it makes others confusing, I will change in next version.
Thanks.

> 
> > progrom execution order is as follows, but clear_bit in processor #1
> > could be reordered right before spin_unlock of processor #1.
> > Then, the page would be stranded on the unevictable list.

-- 
Kind regards,
Minchan Kim
