Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1FAG3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:29:16 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34337 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab1FAG3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:29:14 -0400
Message-ID: <4DE5DC3A.4070303@kernel.dk>
Date: Wed, 01 Jun 2011 08:29:14 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] block: blkdev_get() should acess ->bd_disk only after
 success
References: <20110531235647.GD9048@mtj.dyndns.org>
In-Reply-To: <20110531235647.GD9048@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-01 01:56, Tejun Heo wrote:
> d4dc210f69 (block: don't block events on excl write for non-optical
> devices) added dereferencing of bdev->bd_disk to test
> GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE; however, bdev->bd_disk can be
> %NULL if open failed which can lead to an oops.
> 
> Test the flag after testing open was successful, not before.

Thanks, applied.

-- 
Jens Axboe

