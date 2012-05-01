Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab2EATIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:08:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2EATIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:08:22 -0400
Date: Tue, 1 May 2012 12:08:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] refault distance-based file cache sizing
Message-Id: <20120501120819.0af1e54b.akpm@linux-foundation.org>
In-Reply-To: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 May 2012 10:41:48 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> This series stores file cache eviction information in the vacated page
> cache radix tree slots and uses it on refault to see if the pages
> currently on the active list need to have their status challenged.

So we no longer free the radix-tree node when everything under it has
been reclaimed?  One could create workloads which would result in a
tremendous amount of memory used by radix_tree_node_cachep objects.

So I assume these things get thrown away at some point.  Some
discussion about the life-cycle here would be useful.

