Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab0G0Ig2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:36:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab0G0Ig0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:36:26 -0400
Message-ID: <4C4E99EF.9080809@cn.fujitsu.com>
Date: Tue, 27 Jul 2010 16:33:51 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, jmoyer@redhat.com, czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle tunable
 V3
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com> <4C4D3208.7090703@cn.fujitsu.com> <20100726141053.GE12449@redhat.com>
In-Reply-To: <20100726141053.GE12449@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Jul 26, 2010 at 02:58:16PM +0800, Gui Jianfeng wrote:
> 
> [..]
>> Hi Vivek,
>>
>> I did some tests on single SATA disk on my desktop. With patches applied, seems no
>> regression occurs till now, and have some performance improvement in case of 
>> "Direct Random Reader" mode. Here're some numbers on my box.
>>
> 
> Thanks for testing Gui. "iostest" seems to be working for you. If you had
> to some fixes to make it work on my boxes, do send those to me, and I can
> commit those in my internal git tree.

Hi Vivek,

I didn't modify iostest at all but just upgraded fio to 1.42

Gui

> 
> After running the script, you can also run "iostest -R <result-dir>" and
> that will generate a report. It will not have all this "Starting test..."
> lines and looks nicer.
> 
> Good to know that you don't see any regressions on SATA disk in your
> cgroup testing with this patchset. Little improvement in "drr" might
> be due to the fact that with existing slice_idle=0, we can still do
> some extra idling on service tree and first patch in the series (V4)
> gets rid of that.
> 
> Thanks
> Vivek
> 
>> Vallina kernel:
>>
>> Blkio is already mounted at /cgroup/blkio. Unmounting it
>> DIR=/mnt/iostestmnt/fio                 DEV=/dev/sdb2
>> GROUPMODE=1                             NRGRP=4
>> Will run workloads for increasing number of threads upto a max of 4
>> Starting test for [drr] with set=1 numjobs=1 filesz=512M bs=32k runtime=30
>> Starting test for [drr] with set=1 numjobs=2 filesz=512M bs=32k runtime=30
>> Starting test for [drr] with set=1 numjobs=4 filesz=512M bs=32k runtime=30
>> Finished test for workload [drr]
>> Host=localhost.localdomain     Kernel=2.6.35-rc4-Vivek-+
>> GROUPMODE=1          NRGRP=4
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2
>> Workload=drr      iosched=cfq     Filesz=512M bs=32k
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8
>> =========================================================================
>> AVERAGE[drr]    [bw in KB/s]
>> -------
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total
>> ---     --- --  -----------------------------------
>> drr     1   1   761    761    762    760    3044
>> drr     1   2   185    420    727    1256   2588
>> drr     1   4   180    371    588    863    2002
>>
>>
>> Patched kernel:
>>
>> Blkio is already mounted at /cgroup/blkio. Unmounting it
>> DIR=/mnt/iostestmnt/fio                 DEV=/dev/sdb2
>> GROUPMODE=1                             NRGRP=4
>> Will run workloads for increasing number of threads upto a max of 4
>> Starting test for [drr] with set=1 numjobs=1 filesz=512M bs=32k runtime=30
>> Starting test for [drr] with set=1 numjobs=2 filesz=512M bs=32k runtime=30
>> Starting test for [drr] with set=1 numjobs=4 filesz=512M bs=32k runtime=30
>> Finished test for workload [drr]
>> Host=localhost.localdomain     Kernel=2.6.35-rc4-Vivek-+
>> GROUPMODE=1          NRGRP=4
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2
>> Workload=drr      iosched=cfq     Filesz=512M bs=32k
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8
>> =========================================================================
>> AVERAGE[drr]    [bw in KB/s]
>> -------
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total
>> ---     --- --  -----------------------------------
>> drr     1   1   323    671    1030   1378   3402
>> drr     1   2   165    391    686    1144   2386
>> drr     1   4   185    373    612    873    2043
>>
>> Thanks
>> Gui
>>
>>> Thanks
>>> Vivek
>>>
> 
> 

