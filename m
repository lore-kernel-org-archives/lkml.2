Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2JGMIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 08:08:48 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:51933 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752943Ab2JGMIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 08:08:38 -0400
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=utf-8
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
Date: Sun, 7 Oct 2012 16:08:33 +0400
Cc: "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com> <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com> <1349553966.12699.132.camel@kjgkr> <50712AAA.5030807@gmail.com> <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Oct 7, 2012, at 1:31 PM, Jaegeuk Kim wrote:

>> -----Original Message-----
>> From: Marco Stornelli [mailto:marco.stornelli@gmail.com]
>> Sent: Sunday, October 07, 2012 4:10 PM
>> To: Jaegeuk Kim
>> Cc: Vyacheslav Dubeyko; jaegeuk.kim@samsung.com; Al Viro; tytso@mit.edu; gregkh@linuxfoundation.org;
>> linux-kernel@vger.kernel.org; chur.lee@samsung.com; cm224.lee@samsung.com; jooyoung.hwang@samsung.com;
>> linux-fsdevel@vger.kernel.org
>> Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
>> 
>> Il 06/10/2012 22:06, Jaegeuk Kim ha scritto:
>>> 2012-10-06 (토), 17:54 +0400, Vyacheslav Dubeyko:
>>>> Hi Jaegeuk,
>>> 
>>> Hi.
>>> We know each other, right? :)
>>> 
>>>> 
>>>>> From:	 	김재극 <jaegeuk.kim@samsung.com>
>>>>> To:	 	viro@zeniv.linux.org.uk, 'Theodore Ts'o' <tytso@mit.edu>,
>> gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, chur.lee@samsung.com, cm224.lee@samsung.com,
>> jaegeuk.kim@samsung.com, jooyoung.hwang@samsung.com
>>>>> Subject:	 	[PATCH 00/16] f2fs: introduce flash-friendly file system
>>>>> Date:	 	Fri, 05 Oct 2012 20:55:07 +0900
>>>>> 
>>>>> This is a new patch set for the f2fs file system.
>>>>> 
>>>>> What is F2FS?
>>>>> =============
>>>>> 
>>>>> NAND flash memory-based storage devices, such as SSD, eMMC, and SD cards, have
>>>>> been widely being used for ranging from mobile to server systems. Since they are
>>>>> known to have different characteristics from the conventional rotational disks,
>>>>> a file system, an upper layer to the storage device, should adapt to the changes
>>>>> from the sketch.
>>>>> 
>>>>> F2FS is a new file system carefully designed for the NAND flash memory-based storage
>>>>> devices. We chose a log structure file system approach, but we tried to adapt it
>>>>> to the new form of storage. Also we remedy some known issues of the very old log
>>>>> structured file system, such as snowball effect of wandering tree and high cleaning
>>>>> overhead.
>>>>> 
>>>>> Because a NAND-based storage device shows different characteristics according to
>>>>> its internal geometry or flash memory management scheme aka FTL, we add various
>>>>> parameters not only for configuring on-disk layout, but also for selecting allocation
>>>>> and cleaning algorithms.
>>>>> 
>>>> 
>>>> What about F2FS performance? Could you share benchmarking results of the new file system?
>>>> 
>>>> It is very interesting the case of aged file system. How is GC's implementation efficient? Could
>> you share benchmarking results for the very aged file system state?
>>>> 
>>> 
>>> Although I have benchmark results, currently I'd like to see the results
>>> measured by community as a black-box. As you know, the results are very
>>> dependent on the workloads and parameters, so I think it would be better
>>> to see other results for a while.
>>> Thanks,
>>> 
>> 
>> 1) Actually it's a strange approach. If you have got any results you
>> should share them with the community explaining how (the workload, hw
>> and so on) your benchmark works and the specific condition. I really
>> don't like the approach "I've got the results but I don't say anything,
>> if you want a number, do it yourself".
> 
> It's definitely right, and I meant *for a while*.
> I just wanted to avoid arguing with how to age file system in this time.
> Before then, I share the primitive results as follows.
> 
> 1. iozone in Panda board
> - ARM A9
> - DRAM : 1GB
> - Kernel: Linux 3.3
> - Partition: 12GB (64GB Samsung eMMC)
> - Tested on 2GB file
> 
>           seq. read, seq. write, rand. read, rand. write
> - ext4:    30.753         17.066       5.06         4.15
> - f2fs:    30.71          16.906       5.073       15.204
> 
> 2. iozone in Galaxy Nexus
> - DRAM : 1GB
> - Android 4.0.4_r1.2
> - Kernel omap 3.0.8
> - Partition: /data, 12GB
> - Tested on 2GB file
> 
>           seq. read, seq. write, rand. read,  rand. write
> - ext4:    29.88        12.83         11.43          0.56
> - f2fs:    29.70        13.34         10.79         12.82
> 


This is results for non-aged filesystem state. Am I correct?


> Due to the company secret, I expect to show other results after presenting f2fs at korea linux forum.
> 
>> 2) For a new filesystem you should send the patches to linux-fsdevel.
> 
> Yes, that was totally my mistake.
> 
>> 3) It's not clear the pros/cons of your filesystem, can you share with
>> us the main differences with the current fs already in mainline? Or is
>> it a company secret?
> 
> After forum, I can share the slides, and I hope they will be useful to you.
> 
> Instead, let me summarize at a glance compared with other file systems.
> Here are several log-structured file systems.
> Note that, F2FS operates on top of block device with consideration on the FTL behavior.
> So, JFFS2, YAFFS2, and UBIFS are out-of scope, since they are designed for raw NAND flash.
> LogFS is initially designed for raw NAND flash, but expanded to block device.
> But, I don't know whether it is stable or not.
> NILFS2 is one of major log-structured file systems, which supports multiple snap-shots.
> IMO, that feature is quite promising and important to users, but it may degrade the performance.
> There is a trade-off between functionalities and performance.
> F2FS chose high performance without any further fancy functionalities.
> 

Performance is a good goal. But fault-tolerance is also very important point. Filesystems are used by users, so, it is very important to guarantee reliability of data keeping. Degradation of performance by means of snapshots is arguable point. Snapshots can solve the problem not only some unpredictable environmental issues but also user's erroneous behavior.

As I understand, it is not possible to have a perfect performance in all possible workloads. Could you point out what workloads are the best way of F2FS using?

> Maybe or obviously it is possible to optimize ext4 or btrfs to flash storages.
> IMHO, however, they are originally designed for HDDs, so that it may or may not suffer from fundamental designs.
> I don't know, but why not designing a new file system for flash storages as a counterpart?
> 

Yes, it is possible. But F2FS is not flash oriented filesystem as JFFS2, YAFFS2, UBIFS but block-oriented filesystem. So, F2FS design is restricted by block-layer's opportunities in the using of flash storages' peculiarities. Could you point out key points of F2FS design that makes this design fundamentally unique?

With the best regards,
Vyacheslav Dubeyko.


>> 
>> Marco
> 
> ---
> Jaegeuk Kim
> Samsung
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

