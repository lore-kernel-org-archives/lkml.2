Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab0GZOLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 10:11:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab0GZOLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 10:11:06 -0400
Date: Mon, 26 Jul 2010 10:10:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, jmoyer@redhat.com, czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle
 tunable V3
Message-ID: <20100726141053.GE12449@redhat.com>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
 <4C4D3208.7090703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4D3208.7090703@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 02:58:16PM +0800, Gui Jianfeng wrote:

[..]
> Hi Vivek,
> 
> I did some tests on single SATA disk on my desktop. With patches applied, seems no
> regression occurs till now, and have some performance improvement in case of 
> "Direct Random Reader" mode. Here're some numbers on my box.
> 

Thanks for testing Gui. "iostest" seems to be working for you. If you had
to some fixes to make it work on my boxes, do send those to me, and I can
commit those in my internal git tree.

After running the script, you can also run "iostest -R <result-dir>" and
that will generate a report. It will not have all this "Starting test..."
lines and looks nicer.

Good to know that you don't see any regressions on SATA disk in your
cgroup testing with this patchset. Little improvement in "drr" might
be due to the fact that with existing slice_idle=0, we can still do
some extra idling on service tree and first patch in the series (V4)
gets rid of that.

Thanks
Vivek

> Vallina kernel:
> 
> Blkio is already mounted at /cgroup/blkio. Unmounting it
> DIR=/mnt/iostestmnt/fio                 DEV=/dev/sdb2
> GROUPMODE=1                             NRGRP=4
> Will run workloads for increasing number of threads upto a max of 4
> Starting test for [drr] with set=1 numjobs=1 filesz=512M bs=32k runtime=30
> Starting test for [drr] with set=1 numjobs=2 filesz=512M bs=32k runtime=30
> Starting test for [drr] with set=1 numjobs=4 filesz=512M bs=32k runtime=30
> Finished test for workload [drr]
> Host=localhost.localdomain     Kernel=2.6.35-rc4-Vivek-+
> GROUPMODE=1          NRGRP=4
> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2
> Workload=drr      iosched=cfq     Filesz=512M bs=32k
> group_isolation=1 slice_idle=0    group_idle=8    quantum=8
> =========================================================================
> AVERAGE[drr]    [bw in KB/s]
> -------
> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total
> ---     --- --  -----------------------------------
> drr     1   1   761    761    762    760    3044
> drr     1   2   185    420    727    1256   2588
> drr     1   4   180    371    588    863    2002
> 
> 
> Patched kernel:
> 
> Blkio is already mounted at /cgroup/blkio. Unmounting it
> DIR=/mnt/iostestmnt/fio                 DEV=/dev/sdb2
> GROUPMODE=1                             NRGRP=4
> Will run workloads for increasing number of threads upto a max of 4
> Starting test for [drr] with set=1 numjobs=1 filesz=512M bs=32k runtime=30
> Starting test for [drr] with set=1 numjobs=2 filesz=512M bs=32k runtime=30
> Starting test for [drr] with set=1 numjobs=4 filesz=512M bs=32k runtime=30
> Finished test for workload [drr]
> Host=localhost.localdomain     Kernel=2.6.35-rc4-Vivek-+
> GROUPMODE=1          NRGRP=4
> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2
> Workload=drr      iosched=cfq     Filesz=512M bs=32k
> group_isolation=1 slice_idle=0    group_idle=8    quantum=8
> =========================================================================
> AVERAGE[drr]    [bw in KB/s]
> -------
> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total
> ---     --- --  -----------------------------------
> drr     1   1   323    671    1030   1378   3402
> drr     1   2   165    391    686    1144   2386
> drr     1   4   185    373    612    873    2043
> 
> Thanks
> Gui
> 
> > 
> > Thanks
> > Vivek
> > 
