Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab2IURva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:51:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab2IURv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:51:28 -0400
Date: Fri, 21 Sep 2012 14:51:15 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] mm: compaction: Acquire the zone->lru_lock as late
 as possible
Message-ID: <20120921175115.GE6665@optiplex.redhat.com>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
 <1348224383-1499-6-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348224383-1499-6-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:46:19AM +0100, Mel Gorman wrote:
> Compactions migrate scanner acquires the zone->lru_lock when scanning a range
> of pages looking for LRU pages to acquire. It does this even if there are
> no LRU pages in the range. If multiple processes are compacting then this
> can cause severe locking contention. To make matters worse commit b2eef8c0
> (mm: compaction: minimise the time IRQs are disabled while isolating pages
> for migration) releases the lru_lock every SWAP_CLUSTER_MAX pages that are
> scanned.
> 
> This patch makes two changes to how the migrate scanner acquires the LRU
> lock. First, it only releases the LRU lock every SWAP_CLUSTER_MAX pages if
> the lock is contended. This reduces the number of times it unnecessarily
> disables and re-enables IRQs. The second is that it defers acquiring the
> LRU lock for as long as possible. If there are no LRU pages or the only
> LRU pages are transhuge then the LRU lock will not be acquired at all
> which reduces contention on zone->lru_lock.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Rik van Riel <riel@redhat.com>
> ---

Acked-by: Rafael Aquini <aquini@redhat.com>

