Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab2JPHIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:08:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43716 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab2JPHIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <20121016054946.GA3934@barrios>
References: <1350278059-14904-1-git-send-email-ming.lei@canonical.com>
	<1350278059-14904-2-git-send-email-ming.lei@canonical.com>
	<20121015154724.GA2840@barrios>
	<CACVXFVM09H=8ZuFSzkcN1NmOCR1pcPUsuUyT9tpR0doVam2BiQ@mail.gmail.com>
	<20121016054946.GA3934@barrios>
Date: Tue, 16 Oct 2012 15:08:41 +0800
Message-ID: <CACVXFVOdohPprD7N69=Tz2keTbLG7b-s5324OUX-oY84Jszumg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] mm: teach mm by current context info to not do
 I/O during memory allocation
From: Ming Lei <ming.lei@canonical.com>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jiri.kosina@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 1:49 PM, Minchan Kim <minchan@kernel.org> wrote:
>
> Fair enough but it wouldn't be a good idea that add new unlikely branch
> in allocator's fast path. Please move the check into slow path which could
> be in __alloc_pages_slowpath.

Thanks for your comment.

I have considered to add the branch into gfp_to_alloc_flags() before,
but didn't do it because I see that get_page_from_freelist() may use
the GFP_IO or GFP_FS flag at least in zone_reclaim() path.

So could you make sure it is safe to move the branch into
__alloc_pages_slowpath()?  If so, I will add the check into
gfp_to_alloc_flags().


Thanks,
--
Ming Lei
