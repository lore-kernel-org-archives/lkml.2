Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab1DSLvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:51:21 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42156 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab1DSLvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:51:20 -0400
Message-ID: <4DAD773B.3060602@kernel.dk>
Date: Tue, 19 Apr 2011 13:51:23 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Remove the extra check in queue_requests_store.
References: <1303201617-18122-1-git-send-email-tm@tao.ma>
In-Reply-To: <1303201617-18122-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-19 10:26, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In queue_requests_store, the code looks like
> 	if (rl->count[BLK_RW_SYNC] >= q->nr_requests) {
> 		blk_set_queue_full(q, BLK_RW_SYNC);
> 	} else if (rl->count[BLK_RW_SYNC]+1 <= q->nr_requests) {
> 		blk_clear_queue_full(q, BLK_RW_SYNC);
> 		wake_up(&rl->wait[BLK_RW_SYNC]);
> 	}
> If we don't satify the situation of "if", we can get that
> rl->count[BLK_RW_SYNC} < q->nr_quests. It is the same as
> rl->count[BLK_RW_SYNC]+1 <= q->nr_requests.
> All the "else" should satisfy the "else if" check so it isn't
> needed actually.

Thanks, applied.

-- 
Jens Axboe

