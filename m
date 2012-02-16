Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab2BPVmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:42:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab2BPVmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:42:49 -0500
Date: Thu, 16 Feb 2012 22:42:45 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kernel-team@fedoraproject.org
Subject: Re: exit_mmap() BUG_ON triggering since 3.1
Message-ID: <20120216214245.GD23585@redhat.com>
References: <20120215183317.GA26977@redhat.com>
 <alpine.LSU.2.00.1202151801020.19691@eggly.anvils>
 <20120216070753.GA23585@redhat.com>
 <alpine.LSU.2.00.1202160130500.16147@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1202160130500.16147@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 01:53:04AM -0800, Hugh Dickins wrote:
> Yes (and I think less troublesome than most BUGs, coming at exit
> while not holding locks; though we could well make it a WARN_ON,
> I don't think that existed back in the day).

A WARN_ON would be fine with me, go ahead if you prefer it... only
risk would be to go unnoticed or be underestimated. I am ok with the
BUG_ON too (even if this time it triggered false positives... sigh).

> Acked-by: Hugh Dickins <hughd@google.com>

Thanks for the quick review!

> In looking into the bug, it had actually bothered me a little that you
> were setting aside those pages, yet not counting them into nr_ptes;
> though the only thing that cares is oom_kill.c, and the count of pages
> in each hugepage can only dwarf the count in nr_ptes (whereas, without
> hugepages, it's possible to populate very sparsely and nr_ptes become
> significant).

Agreed, it's not significant either ways.

Running my two primary systems with this applied for half a day and no
problem so far so it should be good for -mm at least.
