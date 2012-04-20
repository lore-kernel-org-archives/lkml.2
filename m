Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2DTIKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:10:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45450 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab2DTIKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:10:35 -0400
Date: Fri, 20 Apr 2012 10:10:31 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block: fixes for long standing issues
Message-ID: <20120420081031.GI7505@kernel.dk>
References: <1334878164-24788-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334878164-24788-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19 2012, Tejun Heo wrote:
> Hello,
> 
> This patchset fixes two long standing issues and one relatively new
> css ref leak.
> 
> a. elvpriv alloc failure, including ioc and icq failures, fails
>    request allocation.  As those aren't mempool backed and may fail
>    indefinitely, this can lead to deadlock under memory pressure.
> 
> b. blkgs don't have proper indexing.  With enough number of
>    request_queues and blk-throttle enabled, block layer can spend
>    considerable amount of cpu cycles walking the same list over and
>    over again.
> 
> c. __blkg_lookup_create() was leaking a css ref on failure path.
> 
> This patchset contains the following four patches.
> 
>  0001-block-collapse-blk_alloc_request-into-get_request.patch
>  0002-block-fix-elvpriv-allocation-failure-handling.patch
>  0003-blkcg-fix-blkcg-css-ref-leak-in-__blkg_lookup_create.patch
>  0004-blkcg-use-radix-tree-to-index-blkgs-from-blkcg.patch
> 
> 0001-0002 fix #a.  0003 fixes #c.  0004 fixes #b.
> 
> This patchset is on top of
> 
>   block/for-3.5/core 5bc4afb1ec "blkcg: drop BLKCG_STAT_{PRIV|POL|OFF} macros"
> + [1] [PATCHSET] block: per-queue policy activation, take#2
> + [2] [PATCHSET] block: cosmetic updates to blkcg API

Applied, thanks Tejun.

-- 
Jens Axboe

