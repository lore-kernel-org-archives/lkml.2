Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2ITSyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:54:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab2ITSyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:54:12 -0400
Message-ID: <505B6647.1080005@redhat.com>
Date: Thu, 20 Sep 2012 14:53:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Avi Kivity <avi@redhat.com>, QEMU-devel <qemu-devel@nongnu.org>,
        KVM <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] mm: compaction: Abort compaction loop if lock is
 contended or run too long
References: <1348149875-29678-1-git-send-email-mgorman@suse.de> <1348149875-29678-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1348149875-29678-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 10:04 AM, Mel Gorman wrote:
> From: Shaohua Li <shli@fusionio.com>
>
> Changelog since V2
> o Fix BUG_ON triggered due to pages left on cc.migratepages
> o Make compact_zone_order() require non-NULL arg `contended'
>
> Changelog since V1
> o only abort the compaction if lock is contended or run too long
> o Rearranged the code by Andrea Arcangeli.
>
> isolate_migratepages_range() might isolate no pages if for example when
> zone->lru_lock is contended and running asynchronous compaction. In this
> case, we should abort compaction, otherwise, compact_zone will run a
> useless loop and make zone->lru_lock is even contended.
>
> [minchan@kernel.org: Putback pages isolated for migration if aborting]
> [akpm@linux-foundation.org: compact_zone_order requires non-NULL arg contended]
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

