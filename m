Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab2JYC5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:57:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55744 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab2JYC5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:57:12 -0400
Date: Wed, 24 Oct 2012 19:57:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Linux-MM <linux-mm@kvack.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] mm: compaction: Move migration fail/success stats
 to migrate.c
In-Reply-To: <1350892791-2682-2-git-send-email-mgorman@suse.de>
Message-ID: <alpine.DEB.2.00.1210241953280.2294@chino.kir.corp.google.com>
References: <1350892791-2682-1-git-send-email-mgorman@suse.de> <1350892791-2682-2-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Mel Gorman wrote:

> The compact_pages_moved and compact_pagemigrate_failed events are
> convenient for determining if compaction is active and to what
> degree migration is succeeding but it's at the wrong level. Other
> users of migration may also want to know if migration is working
> properly and this will be particularly true for any automated
> NUMA migration. This patch moves the counters down to migration
> with the new events called pgmigrate_success and pgmigrate_fail.
> The compact_blocks_moved counter is removed because while it was
> useful for debugging initially, it's worthless now as no meaningful
> conclusions can be drawn from its value.
> 

Agreed, "compact_blocks_moved" should have been named 
"compact_blocks_scanned" to accurately describe what it was representing.

> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David Rientjes <rientjes@google.com>
