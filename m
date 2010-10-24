Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab0JXUHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 16:07:50 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59700 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944Ab0JXUHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 16:07:49 -0400
Message-ID: <4CC4920A.5050100@kernel.dk>
Date: Sun, 24 Oct 2010 22:07:38 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: OOPs on loop module removal
References: <4CC48587.5010907@redhat.com>
In-Reply-To: <4CC48587.5010907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-24 21:14, Milan Broz wrote:
> 
> 
> Hi,
> Simple modprobe loop ; rmmod loop
> on Linus' tree now produces now OOPS.
> 
> Bisected to patch (and reverting fixes problem)
> 
> commit 7681bfeeccff5efa9eb29bf09249a3c400b15327
> Author: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Date:   Tue Oct 19 09:05:00 2010 +0200
> 
>     block: fix accounting bug on cross partition merges
> 
> The problem is probably that patch uses directly q->queue_lock
> even if queue is being destroyed (QUEUE_FLAG_DEAD is set).
> See what loop (and not only this code) does:
> 
>         blk_cleanup_queue(lo->lo_queue);
> 	put_disk(lo->lo_disk);

Yep that commit was not the most fortunate one. I will send out a revert
now, which will gives us time to fix this for real without rushing
things.

-- 
Jens Axboe

