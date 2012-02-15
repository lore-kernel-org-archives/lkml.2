Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab2BOP6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:58:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:42879 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2BOP6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:58:15 -0500
Message-ID: <4F3BD5FC.30101@kernel.dk>
Date: Wed, 15 Feb 2012 16:57:48 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH UPDATED block/for-linus] block: blk-throttle should be
 drained regardless of q->elevator
References: <20120213225248.GH12117@google.com> <20120214011427.GJ12117@google.com>
In-Reply-To: <20120214011427.GJ12117@google.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-14 02:14, Tejun Heo wrote:
> Currently, blk_cleanup_queue() doesn't call elv_drain_elevator() if
> q->elevator doesn't exist; however, bio based drivers don't have
> elevator initialized but can still use blk-throttle.  This patch moves
> q->elevator test inside blk_drain_queue() such that only
> elv_drain_elevator() is skipped if !q->elevator.
> 
> -v2: loop can have registered queue which has NULL request_fn.  Make
>      sure we don't call into __blk_run_queue() in such cases.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Vivek Goyal <vgoyal@redhat.com>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> ---
> Added check against NULL q->request_fn for loop driver.  Thanks.

Applied, thanks.

-- 
Jens Axboe

