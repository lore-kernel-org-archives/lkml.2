Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab2JGJbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 05:31:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45077 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2JGJbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 05:31:33 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-b2-50714bf39a21
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>
Cc: "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
 <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com>
 <1349553966.12699.132.camel@kjgkr> <50712AAA.5030807@gmail.com>
In-reply-to: <50712AAA.5030807@gmail.com>
Subject: RE: [PATCH 00/16] f2fs: introduce flash-friendly file system
Date: Sun, 07 Oct 2012 18:31:30 +0900
Message-id: <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2kW6PCdA0OSYoQSGeI65om/ih+WgAAsd3g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jQd3P3oUBBmtnilrs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVs7ootOKhTsfLRA9YGxkdKXYycHBICJhIv2/YwQ9hi
	EhfurWfrYuTiEBKYzijReXQ6E4Tzj1Hi5LIjLF2MHBxsAtoSm/cbgDSICERJvJ3ZC1bDLNDF
	JLFh2Wyo7q2MElP//GEBqeIU0JToeH6MFcQWFnCVaP/TzghiswioSjQ0X2ICsXkFbCU6f82F
	sgUlfky+B7aMWUBdYsqUXJAwM9DeJ+8usIKEJYDCj/7qQtxgJNG8/hgjRImIxL4X7xgnMArN
	QjJoFsKgWUgGzULSsYCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcDg/k9rBuLLB4hCj
	AAejEg/vjosFAUKsiWXFlbmHGCU4mJVEeBvMCwOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZ7
	pAQICaQnlqRmp6YWpBbBZJk4OKUaGJtPGzp/VRBV4vAtmXX7Yq+W9rlmPS/+NS0TWHOfPlhR
	sMVanimdJ3CDm+Rsj60Fivt9y/dcrHsom7zu5ta1VwL45Hi6Di7oqnubHXxiSmTnxB0vtjy+
	8+bRrqU63nx775yXn6fTWb4pOqskn3dKsJH2LD9hz4mTEhfby7kIGqeIS/ZxdS+tUWIpzkg0
	1GIuKk4EALyFKB9jAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Marco Stornelli [mailto:marco.stornelli@gmail.com]
> Sent: Sunday, October 07, 2012 4:10 PM
> To: Jaegeuk Kim
> Cc: Vyacheslav Dubeyko; jaegeuk.kim@samsung.com; Al Viro; tytso@mit.edu; gregkh@linuxfoundation.org;
> linux-kernel@vger.kernel.org; chur.lee@samsung.com; cm224.lee@samsung.com; jooyoung.hwang@samsung.com;
> linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
> 
> Il 06/10/2012 22:06, Jaegeuk Kim ha scritto:
> > 2012-10-06 (토), 17:54 +0400, Vyacheslav Dubeyko:
> >> Hi Jaegeuk,
> >
> > Hi.
> > We know each other, right? :)
> >
> >>
> >>> From:	 	김재극 <jaegeuk.kim@samsung.com>
> >>> To:	 	viro@zeniv.linux.org.uk, 'Theodore Ts'o' <tytso@mit.edu>,
> gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, chur.lee@samsung.com, cm224.lee@samsung.com,
> jaegeuk.kim@samsung.com, jooyoung.hwang@samsung.com
> >>> Subject:	 	[PATCH 00/16] f2fs: introduce flash-friendly file system
> >>> Date:	 	Fri, 05 Oct 2012 20:55:07 +0900
> >>>
> >>> This is a new patch set for the f2fs file system.
> >>>
> >>> What is F2FS?
> >>> =============
> >>>
> >>> NAND flash memory-based storage devices, such as SSD, eMMC, and SD cards, have
> >>> been widely being used for ranging from mobile to server systems. Since they are
> >>> known to have different characteristics from the conventional rotational disks,
> >>> a file system, an upper layer to the storage device, should adapt to the changes
> >>> from the sketch.
> >>>
> >>> F2FS is a new file system carefully designed for the NAND flash memory-based storage
> >>> devices. We chose a log structure file system approach, but we tried to adapt it
> >>> to the new form of storage. Also we remedy some known issues of the very old log
> >>> structured file system, such as snowball effect of wandering tree and high cleaning
> >>> overhead.
> >>>
> >>> Because a NAND-based storage device shows different characteristics according to
> >>> its internal geometry or flash memory management scheme aka FTL, we add various
> >>> parameters not only for configuring on-disk layout, but also for selecting allocation
> >>> and cleaning algorithms.
> >>>
> >>
> >> What about F2FS performance? Could you share benchmarking results of the new file system?
> >>
> >> It is very interesting the case of aged file system. How is GC's implementation efficient? Could
> you share benchmarking results for the very aged file system state?
> >>
> >
> > Although I have benchmark results, currently I'd like to see the results
> > measured by community as a black-box. As you know, the results are very
> > dependent on the workloads and parameters, so I think it would be better
> > to see other results for a while.
> > Thanks,
> >
> 
> 1) Actually it's a strange approach. If you have got any results you
> should share them with the community explaining how (the workload, hw
> and so on) your benchmark works and the specific condition. I really
> don't like the approach "I've got the results but I don't say anything,
> if you want a number, do it yourself".

It's definitely right, and I meant *for a while*.
I just wanted to avoid arguing with how to age file system in this time.
Before then, I share the primitive results as follows.

1. iozone in Panda board
 - ARM A9
 - DRAM : 1GB
 - Kernel: Linux 3.3
 - Partition: 12GB (64GB Samsung eMMC)
 - Tested on 2GB file

           seq. read, seq. write, rand. read, rand. write
 - ext4:    30.753         17.066       5.06         4.15
 - f2fs:    30.71          16.906       5.073       15.204

2. iozone in Galaxy Nexus
 - DRAM : 1GB
 - Android 4.0.4_r1.2
 - Kernel omap 3.0.8
 - Partition: /data, 12GB
 - Tested on 2GB file

           seq. read, seq. write, rand. read,  rand. write
 - ext4:    29.88        12.83         11.43          0.56
 - f2fs:    29.70        13.34         10.79         12.82

Due to the company secret, I expect to show other results after presenting f2fs at korea linux forum.

> 2) For a new filesystem you should send the patches to linux-fsdevel.

Yes, that was totally my mistake.

> 3) It's not clear the pros/cons of your filesystem, can you share with
> us the main differences with the current fs already in mainline? Or is
> it a company secret?

After forum, I can share the slides, and I hope they will be useful to you.

Instead, let me summarize at a glance compared with other file systems.
Here are several log-structured file systems.
Note that, F2FS operates on top of block device with consideration on the FTL behavior.
So, JFFS2, YAFFS2, and UBIFS are out-of scope, since they are designed for raw NAND flash.
LogFS is initially designed for raw NAND flash, but expanded to block device.
But, I don't know whether it is stable or not.
NILFS2 is one of major log-structured file systems, which supports multiple snap-shots.
IMO, that feature is quite promising and important to users, but it may degrade the performance.
There is a trade-off between functionalities and performance.
F2FS chose high performance without any further fancy functionalities.

Maybe or obviously it is possible to optimize ext4 or btrfs to flash storages.
IMHO, however, they are originally designed for HDDs, so that it may or may not suffer from fundamental designs.
I don't know, but why not designing a new file system for flash storages as a counterpart?

> 
> Marco

---
Jaegeuk Kim
Samsung

