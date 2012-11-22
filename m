Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab2KVUJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:09:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36891 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab2KVUJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:09:29 -0500
Message-ID: <50ADFEC2.8040100@kernel.dk>
Date: Thu, 22 Nov 2012 11:30:26 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Don't access request after it might be freed
References: <1353578411-23527-1-git-send-email-roland@kernel.org>
In-Reply-To: <1353578411-23527-1-git-send-email-roland@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-22 11:00, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> After we've done __elv_add_request() and __blk_run_queue() in
> blk_execute_rq_nowait(), the request might finish and be freed
> immediately.  Therefore checking if the type is REQ_TYPE_PM_RESUME
> isn't safe afterwards, because if it isn't, rq might be gone.
> Instead, check beforehand and stash the result in a temporary.
> 
> This fixes crashes in blk_execute_rq_nowait() I get occasionally when
> running with lots of memory debugging options enabled -- I think this
> race is usually harmless because the window for rq to be reallocated
> is so small.

Thanks Roland, that's obviously a bug, not safe to touch the request
even after insertion, let alone running the queue. Applied.

-- 
Jens Axboe

