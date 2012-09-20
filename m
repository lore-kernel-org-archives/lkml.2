Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2ITS6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:58:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab2ITSya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:54:30 -0400
Message-ID: <505B6658.1080706@redhat.com>
Date: Thu, 20 Sep 2012 14:54:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Avi Kivity <avi@redhat.com>, QEMU-devel <qemu-devel@nongnu.org>,
        KVM <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] mm: compaction: Acquire the zone->lru_lock as late
 as possible
References: <1348149875-29678-1-git-send-email-mgorman@suse.de> <1348149875-29678-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1348149875-29678-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 10:04 AM, Mel Gorman wrote:
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

Acked-by: Rik van Riel <riel@redhat.com>

