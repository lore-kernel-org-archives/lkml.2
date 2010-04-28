Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab0D1Pjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:39:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab0D1Pjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:39:47 -0400
Date: Wed, 28 Apr 2010 17:39:12 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
Message-ID: <20100428153912.GS510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <1272403852-10479-3-git-send-email-mel@csn.ul.ie>
 <20100427231007.GA510@random.random>
 <20100428091555.GB15815@csn.ul.ie>
 <20100428153525.GR510@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428153525.GR510@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another way (not sure if it's good or bad, but it'd clearly avoid the
restarting locks in rmap_walk) would be to allocate a shared lock, and
still share the lock like the anon_vma was shared before. So we have
shorter chains to walk, but still a larger lock, so we've to take just
one and be safe.

spin_lock(&vma->anon_vma->shared_anon_vma_lock->lock)

something like that...
