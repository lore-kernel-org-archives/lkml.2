Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2KLUcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:32:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab2KLUce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:32:34 -0500
Date: Mon, 12 Nov 2012 15:32:21 -0500
From: Johannes Weiner <jweiner@redhat.com>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Mandeep Singh Baines <msb@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, Aaron Durbin <adurbin@chromium.org>,
        Puneet Kumar <puneetster@chromium.org>
Subject: Re: [PATCH] mm: Fix calculation of dirtyable memory
Message-ID: <20121112203221.GB4511@redhat.com>
References: <20121109023638.GA11105@localhost>
 <1352748928-738-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352748928-738-1-git-send-email-sonnyrao@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 11:35:28AM -0800, Sonny Rao wrote:
> The system uses global_dirtyable_memory() to calculate
> number of dirtyable pages/pages that can be allocated
> to the page cache.  A bug causes an underflow thus making
> the page count look like a big unsigned number.  This in turn
> confuses the dirty writeback throttling to aggressively write
> back pages as they become dirty (usually 1 page at a time).
> 
> Fix is to ensure there is no underflow while doing the math.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Puneet Kumar <puneetster@chromium.org>

Thanks for debugging and sending in the patch.

It might be useful to note in the changelog that the crawling
writeback problem only affects highmem systems because of the way the
underflowed count of high memory is subtracted from the overall amount
of dirtyable memory.

And that the problem was introduced with v3.2-4896-gab8fabd (which
means that we should include Cc: stable@kernel.org for 3.3+).

The diff itself looks good to me, thanks again:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
