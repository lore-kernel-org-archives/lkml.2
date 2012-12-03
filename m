Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2LCN7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:59:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab2LCN7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:59:39 -0500
Date: Mon, 3 Dec 2012 13:59:34 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/2] mm/rmap: Convert the struct anon_vma::mutex to an
 rwsem
Message-ID: <20121203135934.GM8218@suse.de>
References: <1354305521-11583-1-git-send-email-mingo@kernel.org>
 <CA+55aFwjxm7OYuucHeE2WFr4p+jwr63t=kSdHndta_QkyFbyBQ@mail.gmail.com>
 <20121201094927.GA12366@gmail.com>
 <20121201122649.GA20322@gmail.com>
 <CA+55aFx8QtP0hg8qxn__4vHQuzH7QkhTN-4fwgOpM-A=KuBBjA@mail.gmail.com>
 <20121201184135.GA32449@gmail.com>
 <CA+55aFyq7OaUxcEHXvJhp0T57KN14o-RGxqPmA+ks8ge6zJh5w@mail.gmail.com>
 <20121201201030.GA2704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121201201030.GA2704@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 09:10:30PM +0100, Ingo Molnar wrote:
> 
> Convert the struct anon_vma::mutex to an rwsem, which will help
> in solving a page-migration scalability problem. (Addressed in
> a separate patch.)
> 
> The conversion is simple and straightforward: in every case
> where we mutex_lock()ed we'll now down_write().
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Confirmation from the RT people that they're ok with this would be nice
but otherwise

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
