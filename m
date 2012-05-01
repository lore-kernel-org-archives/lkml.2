Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2EAJa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 05:30:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54361 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2EAJa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 05:30:57 -0400
Message-ID: <1335864640.13683.116.camel@twins>
Subject: Re: [patch 4/5] mm + fs: provide refault distance to page cache
 instantiations
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 01 May 2012 11:30:40 +0200
In-Reply-To: <1335861713-4573-5-git-send-email-hannes@cmpxchg.org>
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
	 <1335861713-4573-5-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 10:41 +0200, Johannes Weiner wrote:
> Every site that does a find_or_create()-style allocation is converted
> to pass this refault information to the page_cache_alloc() family of
> functions, which in turn passes it down to the page allocator via
> current->refault_distance. 

That is rather icky..
