Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1KVGqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 01:46:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:63961 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab1KVGqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 01:46:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,551,1315206000"; 
   d="scan'208";a="77842987"
Subject: Re: [PATCH 7/7] mm: compaction: Introduce sync-light migration for
 use by compaction
From: Shaohua Li <shaohua.li@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1321900608-27687-8-git-send-email-mgorman@suse.de>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
	 <1321900608-27687-8-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 14:56:51 +0800
Message-ID: <1321945011.22361.335.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 02:36 +0800, Mel Gorman wrote:
> This patch adds a lightweight sync migrate operation MIGRATE_SYNC_LIGHT
> mode that avoids writing back pages to backing storage. Async
> compaction maps to MIGRATE_ASYNC while sync compaction maps to
> MIGRATE_SYNC_LIGHT. For other migrate_pages users such as memory
> hotplug, MIGRATE_SYNC is used.
> 
> This avoids sync compaction stalling for an excessive length of time,
> particularly when copying files to a USB stick where there might be
> a large number of dirty pages backed by a filesystem that does not
> support ->writepages.
Hi,
from my understanding, with this, even writes
to /proc/sys/vm/compact_memory doesn't wait for pageout, is this
intended?
on the other hand, MIGRATE_SYNC_LIGHT now waits for pagelock and buffer
lock, so could wait on page read. page read and page out have the same
latency, why takes them different?

Thanks,
Shaohua

