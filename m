Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab0DIH3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 03:29:20 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46773 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab0DIH3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 03:29:17 -0400
Date: Fri, 9 Apr 2010 09:29:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Subject: Re: [PATCH] cfq-iosched: Fix the incorrect timeslice accounting
	with  forced_dispatch.
Message-ID: <20100409072915.GF10103@kernel.dk>
References: <20100409021054.13511.52377.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100409021054.13511.52377.stgit@austin.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08 2010, Divyesh Shah wrote:
> When CFQ dispatches requests forcefully due to a barrier or changing iosched,
> it runs through all cfqq's dispatching requests and then expires each queue.
> However, it does not activate a cfqq before flushing its IOs resulting in
> using stale values for computing slice_used.
> This patch fixes it by calling activate queue before flushing reuqests from
> each queue.
> 
> This is useful mostly for barrier requests because when the iosched is changing
> it really doesnt matter if we have incorrect accounting since we're going to
> break down all structures anyway.
> 
> We also now expire the current timeslice before moving on with the dispatch
> to accurately account slice used for that cfqq.

Good catch, applied for 2.6.34.

-- 
Jens Axboe

