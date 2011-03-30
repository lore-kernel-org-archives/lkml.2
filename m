Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab1C3BMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:12:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62738 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab1C3BMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:12:22 -0400
Message-ID: <4D92838B.4070706@cn.fujitsu.com>
Date: Wed, 30 Mar 2011 09:12:43 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Bug at for-2.6.39/core
References: <4D91AAB9.2000800@cn.fujitsu.com> <4D91AB5C.8030203@kernel.dk>
In-Reply-To: <4D91AB5C.8030203@kernel.dk>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-30 09:10:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-30 09:10:49,
	Serialize complete at 2011-03-30 09:10:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On 2011-03-29 11:47, Gui Jianfeng wrote:
>> Hi Jens,
>>
>> I trigger an OOPS when testing, the following script can reproduce
>> this bug on my box.
>>
>> #!/bin/sh
>>
>> mkdir /mnt/blkio
>> mount -t cgroup -o blkio blkio /mnt/blkio/
>> mkdir /mnt/blkio/test1 /mnt/blkio/test2
>> echo noop > /sys/block/sdb/queue/scheduler
>> dd iflag=direct if=/dev/sdb of=/dev/null bs=4k &
>> echo $! > /mnt/blkio/test1/tasks
>> dd iflag=direct if=/dev/sdb of=/dev/null bs=4k &
>> echo $! > /mnt/blkio/test2/tasks
>> sleep 3
>> echo cfq > /sys/block/sdb/queue/scheduler
>>
>> ----
>> eBUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>> IP: [<ffffffff812200e8>] cfq_completed_request+0x38/0x7f0
> 
> This is a known bug, update to Linus' current -git and it's fixed.

Ok, I see.

Thanks,
Gui

> 
