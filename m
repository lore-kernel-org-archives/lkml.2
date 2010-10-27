Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab0J0EMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 00:12:48 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:47268 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab0J0EMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 00:12:45 -0400
X-ASG-Debug-ID: 1288152764-085b31160001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CC7A686.4070407@fusionio.com>
Date: Tue, 26 Oct 2010 22:11:50 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [warn, 2.6.37-current] loop: sysfs: cannot create duplicate filename
References: <20101027000051.GC32255@dastard>
X-ASG-Orig-Subj: Re: [warn, 2.6.37-current] loop: sysfs: cannot create duplicate filename
In-Reply-To: <20101027000051.GC32255@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1288152764
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0995 1.0000 -1.3958
X-Barracuda-Spam-Score: -1.40
X-Barracuda-Spam-Status: No, SCORE=-1.40 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.44850
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-26 18:00, Dave Chinner wrote:
> Folks,
> 
> I'm getting this warning triggering repeatedly when running xfstests
> on a day old 2.6.37-git tree.
> 
>  [ 3393.738568] ------------[ cut here ]------------
>  [ 3393.739389] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0xc9/0x130()
>  [ 3393.740490] Hardware name: Bochs
>  [ 3393.741041] sysfs: cannot create duplicate filename '/devices/virtual/block/loop0/loop'
>  [ 3393.742439] Modules linked in:
>  [ 3393.742984] Pid: 5360, comm: mount Not tainted 2.6.36-dgc+ #590
>  [ 3393.744125] Call Trace:
>  [ 3393.744555]  [<ffffffff8108492f>] warn_slowpath_common+0x7f/0xc0
>  [ 3393.745545]  [<ffffffff81084a26>] warn_slowpath_fmt+0x46/0x50
>  [ 3393.746493]  [<ffffffff811d1539>] sysfs_add_one+0xc9/0x130
>  [ 3393.747420]  [<ffffffff811d1621>] create_dir+0x81/0xd0
>  [ 3393.748311]  [<ffffffff811d175c>] sysfs_create_subdir+0x1c/0x20
>  [ 3393.749294]  [<ffffffff811d30b8>] internal_create_group+0x58/0x1a0
>  [ 3393.750234]  [<ffffffff811d3233>] sysfs_create_group+0x13/0x20
>  [ 3393.751223]  [<ffffffff81879e66>] lo_ioctl+0x506/0x7b0
>  [ 3393.752111]  [<ffffffff8169b5a8>] __blkdev_driver_ioctl+0x28/0x30
>  [ 3393.753115]  [<ffffffff8169ba8e>] blkdev_ioctl+0x22e/0x6f0
>  [ 3393.754022]  [<ffffffff81190732>] block_ioctl+0x42/0x50
>  [ 3393.754889]  [<ffffffff8116f239>] do_vfs_ioctl+0xa9/0x5a0
>  [ 3393.755803]  [<ffffffff810bdded>] ? trace_hardirqs_on+0xd/0x10
>  [ 3393.756805]  [<ffffffff8116f7b1>] sys_ioctl+0x81/0xa0
>  [ 3393.757647]  [<ffffffff8103a072>] system_call_fastpath+0x16/0x1b
>  [ 3393.758626] ---[ end trace 2a65a71ed74903b0 ]---

Thanks, this is a known bug, I will get the fix expedited.

-- 
Jens Axboe

