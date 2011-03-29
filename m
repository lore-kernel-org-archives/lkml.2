Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1C2JuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:50:22 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42432 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1C2JuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:50:21 -0400
Message-ID: <4D91AB5C.8030203@kernel.dk>
Date: Tue, 29 Mar 2011 11:50:20 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
CC: Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Bug at for-2.6.39/core
References: <4D91AAB9.2000800@cn.fujitsu.com>
In-Reply-To: <4D91AAB9.2000800@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-29 11:47, Gui Jianfeng wrote:
> Hi Jens,
> 
> I trigger an OOPS when testing, the following script can reproduce
> this bug on my box.
> 
> #!/bin/sh
> 
> mkdir /mnt/blkio
> mount -t cgroup -o blkio blkio /mnt/blkio/
> mkdir /mnt/blkio/test1 /mnt/blkio/test2
> echo noop > /sys/block/sdb/queue/scheduler
> dd iflag=direct if=/dev/sdb of=/dev/null bs=4k &
> echo $! > /mnt/blkio/test1/tasks
> dd iflag=direct if=/dev/sdb of=/dev/null bs=4k &
> echo $! > /mnt/blkio/test2/tasks
> sleep 3
> echo cfq > /sys/block/sdb/queue/scheduler
> 
> ----
> eBUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffff812200e8>] cfq_completed_request+0x38/0x7f0

This is a known bug, update to Linus' current -git and it's fixed.

-- 
Jens Axboe

