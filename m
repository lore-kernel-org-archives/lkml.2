Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2FRJhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:37:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2FRJhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:37:45 -0400
Message-ID: <4FDEF73E.3010501@redhat.com>
Date: Mon, 18 Jun 2012 17:39:10 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/3] Improve virtio-blk performance
References: <1340002390-3950-1-git-send-email-asias@redhat.com> <CAJSP0QXOn-5Krm6hSMmm=zRYkG43k9F4Xe6P+ENMFtgMhTupFA@mail.gmail.com>
In-Reply-To: <CAJSP0QXOn-5Krm6hSMmm=zRYkG43k9F4Xe6P+ENMFtgMhTupFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 05:14 PM, Stefan Hajnoczi wrote:
> On Mon, Jun 18, 2012 at 7:53 AM, Asias He <asias@redhat.com> wrote:
>> Fio test shows it gives, 28%, 24%, 21%, 16% IOPS boost and 32%, 17%, 21%, 16%
>> latency improvement for sequential read/write, random read/write respectively.
>
> Sounds great.  What storage configuration did you use (single spinning
> disk, SSD, storage array) and are these numbers for parallel I/O or
> sequential I/O?

I used ramdisk as the backend storage.

> What changed since Minchan worked on this?  I remember he wasn't
> satisfied that this was a clear win.  Your numbers are strong so
> either you fixed something important or you are looking at different
> benchmark configurations.

I am using kvm tool instead qemu. He wasn't satisfied the poor 
sequential performance. I removed the plug and unplug operation and bio 
completion batching. You can grab Michan's patch and make a diff to see 
the details.

Here is the fio's config file.

[global]
exec_prerun="echo 3 > /proc/sys/vm/drop_caches"
group_reporting
norandommap
ioscheduler=noop
thread
bs=512
size=4MB
direct=1
filename=/dev/vdb
numjobs=256
ioengine=aio
iodepth=64
loops=3

[seq-read]
stonewall
rw=read

[seq-write]
stonewall
rw=write

[rnd-read]
stonewall
rw=randread

[rnd-write]
stonewall
rw=randwrite



-- 
Asias


