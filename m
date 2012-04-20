Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2DTR0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:26:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab2DTR0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:26:50 -0400
Date: Fri, 20 Apr 2012 13:26:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] blkcg: use radix tree to index blkgs from blkcg
Message-ID: <20120420172639.GM22419@redhat.com>
References: <1334878164-24788-1-git-send-email-tj@kernel.org>
 <1334878164-24788-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334878164-24788-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 04:29:24PM -0700, Tejun Heo wrote:
> blkg lookup is currently performed by traversing linked list anchored
> at blkcg->blkg_list.  This is very unscalable and with blk-throttle
> enabled and enough request queues on the system, this can get very
> ugly quickly (blk-throttle performs look up on every bio submission).
> 
> This patch makes blkcg use radix tree to index blkgs combined with
> simple last-looked-up hint.  This is mostly identical to how icqs are
> indexed from ioc.
> 
> Note that because __blkg_lookup() may be invoked without holding queue
> lock, hint is only updated from __blkg_lookup_create().  Due to cfq's
> cfqq caching, this makes hint updates overly lazy.  This will be
> improved with scheduled blkcg aware request allocation.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>

Nice to see radix tree lookup and caching hint. Helps with scalability.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
