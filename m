Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2JQK4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:56:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50373 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2JQK4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:56:16 -0400
MIME-Version: 1.0
In-Reply-To: <507E3EA6.5080809@jp.fujitsu.com>
References: <1350403183-12650-1-git-send-email-ming.lei@canonical.com>
	<1350403183-12650-2-git-send-email-ming.lei@canonical.com>
	<507E3EA6.5080809@jp.fujitsu.com>
Date: Wed, 17 Oct 2012 18:56:14 +0800
Message-ID: <CACVXFVN_NNE-ETo6Pno3k0255tKrVJSpvebQf6Ebu4WaMmKc_g@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/3] mm: teach mm by current context info to not do
 I/O during memory allocation
From: Ming Lei <ming.lei@canonical.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        Jiri Kosina <jiri.kosina@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 1:14 PM, Kamezawa Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> I think the idea is reasonable. I have a request.

Thanks for your comment.

>
> In current implemententation of vmscan.c, it seems sc.may_writepage, sc.may_swap
> are handled independent from gfp_mask.
>
> So, could you drop changes from this patch and handle these flags in another patch
> if these flags should be unset if ~GFP_IOFS ?

OK, I agree. In theory,  mm should make sure no I/O is involved if
memory allocation
users passes ~GFP_IOFS.

>
> I think try_to_free_page() path's sc.may_xxxx should be handled in the same way.

Yes, alloc_page_buffers() and dma_alloc_from_contiguous may drop into
the path, so gfp flag should be changed in try_to_free_page() too.


Thanks,
--
Ming Lei
