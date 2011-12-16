Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043Ab1LPDdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 22:33:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab1LPDdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 22:33:24 -0500
Message-ID: <4EEABBE3.1050309@redhat.com>
Date: Thu, 15 Dec 2011 22:32:51 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/11] mm: compaction: Determine if dirty pages can be
 migrated without blocking within ->migratepage
References: <1323877293-15401-1-git-send-email-mgorman@suse.de> <1323877293-15401-6-git-send-email-mgorman@suse.de>
In-Reply-To: <1323877293-15401-6-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 10:41 AM, Mel Gorman wrote:
> Asynchronous compaction is used when allocating transparent hugepages
> to avoid blocking for long periods of time. Due to reports of
> stalling, there was a debate on disabling synchronous compaction
> but this severely impacted allocation success rates. Part of the
> reason was that many dirty pages are skipped in asynchronous compaction
> by the following check;
>
> 	if (PageDirty(page)&&  !sync&&
> 		mapping->a_ops->migratepage != migrate_page)
> 			rc = -EBUSY;
>
> This skips over all mapping aops using buffer_migrate_page()
> even though it is possible to migrate some of these pages without
> blocking. This patch updates the ->migratepage callback with a "sync"
> parameter. It is the responsibility of the callback to fail gracefully
> if migration would block.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
