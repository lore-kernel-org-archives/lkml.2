Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab1JZFmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 01:42:24 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33271 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab1JZFmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 01:42:23 -0400
MIME-Version: 1.0
In-Reply-To: <CADAg6uxLj_ePPbcrVcqcE7y+CxGZfqWUA1zYOtm9e-TYShBDsQ@mail.gmail.com>
References: <CADAg6uxLj_ePPbcrVcqcE7y+CxGZfqWUA1zYOtm9e-TYShBDsQ@mail.gmail.com>
Date: Wed, 26 Oct 2011 13:42:22 +0800
X-Google-Sender-Auth: sjDl3RKTINNpuqgZgum3PNfNTko
Message-ID: <CANejiEWBpeiBKvg+_W5OC0onQQLpAFCsgADWW1mTutUWF9ZQfA@mail.gmail.com>
Subject: Re: Multi-partition block layer behaviour
From: Shaohua Li <shaohua.li@intel.com>
To: Tiju Jacob <jacobtiju@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/26 Tiju Jacob <jacobtiju@gmail.com>:
> Hi All,
>
> We are trying to run fsstress tests on ext4 filesystem with
> linux-3.0.4 on nand flash with our proprietary driver. The test runs
> successfully when run on single partition but fails when run on
> multiple partitions with the bug "BUG: scheduling while atomic:
> fsstress.fork_n/498/0x00000002".
>
> Analysis:
>
> 1. When an I/O request is made to the filesystem, process 'A' acquires
> a mutex FS lock and a mutex block driver lock.
>
> 2. Process 'B' tries to acquire the mutex FS lock, which is not
> available. Hence, it goes to sleep. Due to the new plugging mechanism,
> before going to sleep, shcedule() is invoked which disables preemption
> and the context becomes atomic. In schedule(), the newly added
> blk_flush_plug_list() is invoked which unplugs the block driver.
>
> 3) During unplug operation the block driver tries to acquire the mutex
> lock which fails, because the lock was held by process 'A'. Previous
> invocation of scheudle() in step 2 has already made the context as
> atomic, hence the error "Schedule while atomic" occured.
if blk_flush_plug_list() is called in schedule(), it will use
blk_run_queue_async
to unplug the queue. This runs in a workqueue. So how could this happen?

Thanks,
Shaohua
