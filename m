Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0IDAEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 20:04:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091Ab0IDAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 20:04:13 -0400
Date: Fri, 3 Sep 2010 17:02:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Hugh Dickins <hughd@google.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v2] compaction: fix COMPACTPAGEFAILED counting
Message-Id: <20100903170227.b2f18ba4.akpm@linux-foundation.org>
In-Reply-To: <1283438087-11842-1-git-send-email-minchan.kim@gmail.com>
References: <1283438087-11842-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Sep 2010 23:34:47 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Now update_nr_listpages doesn't have a role. That's because
> lists passed is always empty just after calling migrate_pages.
> The migrate_pages cleans up page list which have failed to migrate
> before returning by aaa994b3.
> 
>  [PATCH] page migration: handle freeing of pages in migrate_pages()
> 
>  Do not leave pages on the lists passed to migrate_pages().  Seems that we will
>  not need any postprocessing of pages.  This will simplify the handling of
>  pages by the callers of migrate_pages().
> 
> At that time, we thought we don't need any postprocessing of pages.
> But the situation is changed. The compaction need to know the number of
> failed to migrate for COMPACTPAGEFAILED stat
> 
> This patch makes new rule for caller of migrate_pages to call putback_lru_pages.
> So caller need to clean up the lists so it has a chance to postprocess the pages.
> [suggested by Christoph Lameter]

I'm having trouble predicting what the user-visible effects of this bug
might be.  Just an inaccuracy in the COMPACTPAGEFAILED vm event?

