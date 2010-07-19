Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966475Ab0GSSoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:44:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966401Ab0GSSoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:44:10 -0400
Message-ID: <4C449CBA.5090703@redhat.com>
Date: Mon, 19 Jul 2010 14:43:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 7/8] writeback: sync old inodes first in background writeback
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie> <1279545090-19169-8-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1279545090-19169-8-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 09:11 AM, Mel Gorman wrote:
> From: Wu Fengguang<fengguang.wu@intel.com>
>
> A background flush work may run for ever. So it's reasonable for it to
> mimic the kupdate behavior of syncing old/expired inodes first.
>
> This behavior also makes sense from the perspective of page reclaim.
> File pages are added to the inactive list and promoted if referenced
> after one recycling. If not referenced, it's very easy for pages to be
> cleaned from reclaim context which is inefficient in terms of IO. If
> background flush is cleaning pages, it's best it cleans old pages to
> help minimise IO from reclaim.
>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Acked-by: Rik van Riel <riel@redhat.com>

It can probably be optimized, but we really need something
like this...
