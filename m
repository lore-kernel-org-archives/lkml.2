Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0D0PjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:39:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab0D0PjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:39:10 -0400
Date: Tue, 27 Apr 2010 17:37:59 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
Message-ID: <20100427153759.GZ8860@random.random>
References: <1272321478-28481-1-git-send-email-mel@csn.ul.ie>
 <1272321478-28481-3-git-send-email-mel@csn.ul.ie>
 <20100427090706.7ca68e12.kamezawa.hiroyu@jp.fujitsu.com>
 <20100427125040.634f56b3.kamezawa.hiroyu@jp.fujitsu.com>
 <20100427085951.GB4895@csn.ul.ie>
 <20100427180949.673350f2.kamezawa.hiroyu@jp.fujitsu.com>
 <20100427102905.GE4895@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427102905.GE4895@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 11:29:05AM +0100, Mel Gorman wrote:
> It could have been in both but the vma lock should have been held across
> the rmap_one. It still reproduces but it's still the right thing to do.
> This is the current version of patch 2/2.

Well, keep in mind I reproduced the swapops bug with 2.6.33 anon-vma
code, it's unlikely that focusing on patch 2 you'll fix bug in
swapops.h. If this is a bug in the new anon-vma code, it needs fixing
of course! But I doubt this bug is related to swapops in execve on the
bprm->p args.

I've yet to check in detail patch 1 sorry, I'll let you know my
opinion about it as soon as I checked it in detail.
