Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2GLCSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:18:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab2GLCSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:18:08 -0400
Date: Wed, 11 Jul 2012 19:21:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH v2 -mm] memcg: prevent from OOM with too many dirty
 pages
Message-Id: <20120711192106.b6b8232f.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1207111818380.1299@eggly.anvils>
References: <1340117404-30348-1-git-send-email-mhocko@suse.cz>
	<20120619150014.1ebc108c.akpm@linux-foundation.org>
	<20120620101119.GC5541@tiehlicka.suse.cz>
	<alpine.LSU.2.00.1207111818380.1299@eggly.anvils>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012 18:57:43 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> --- 3.5-rc6-mm1/mm/vmscan.c	2012-07-11 14:42:13.668335884 -0700
> +++ linux/mm/vmscan.c	2012-07-11 16:01:20.712814127 -0700
> @@ -726,7 +726,8 @@ static unsigned long shrink_page_list(st
>  			 * writeback from reclaim and there is nothing else to
>  			 * reclaim.
>  			 */
> -			if (!global_reclaim(sc) && PageReclaim(page))
> +			if (!global_reclaim(sc) && PageReclaim(page) &&
> +					may_enter_fs)
>  				wait_on_page_writeback(page);
>  			else {
>  				nr_writeback++;

um, that may_enter_fs test got removed because nobody knew why it was
there.  Nobody knew why it was there because it was undocumented.  Do
you see where I'm going with this?

