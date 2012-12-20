Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2LTWqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:46:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab2LTWqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:46:08 -0500
Message-ID: <50D3951E.50107@redhat.com>
Date: Thu, 20 Dec 2012 17:45:50 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: compaction: Do not accidentally skip pageblocks in
 the migrate scanner
References: <20121220142232.GA13367@suse.de>
In-Reply-To: <20121220142232.GA13367@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 09:22 AM, Mel Gorman wrote:
> Compaction uses the ALIGN macro incorrectly with the migrate scanner by
> adding pageblock_nr_pages to a PFN. It happened to work when initially
> implemented as the starting PFN was also aligned but with caching restarts
> and isolating in smaller chunks this is no longer always true. The impact is
> that the migrate scanner scans outside its current pageblock. As pfn_valid()
> is still checked properly it does not cause any failure and the impact
> of the bug is that in some cases it will scan more than necessary when
> it crosses a page boundary but by no more than COMPACT_CLUSTER_MAX. It
> is highly unlikely this is even measurable but it's still wrong so this
> patch addresses the problem.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

