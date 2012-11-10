Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2KJSk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 13:40:29 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60375 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2KJSk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 13:40:27 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
Date: Sat, 10 Nov 2012 19:40:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc4-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: Kim Jaegeuk <jaegeuk.kim@gmail.com>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-fsdevel@vger.kernel.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com> <CAOtxgye-sqJFe17EyfJQ0RrMwQqsPbDv5m+4cJT0BjnRnGv56w@mail.gmail.com> <201211101933.38434.Martin@lichtvoll.de> (sfid-20121110_193431_591556_1E639DC0)
In-Reply-To: <201211101933.38434.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201211101940.25950.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 10. November 2012 schrieb Martin Steigerwald:
> merkaba:~> mkfs.f2fs /dev/sdb1              
> Info: sector size = 512
> Info: total sectors = 4093951 (in 512bytes)
> Info: zone aligned segment0 blkaddr: 256
> Info: This device doesn't support TRIM
> Info: format successful
> merkaba:~> mount -t f2fs /dev/sdb1 /mnt/zeit
> merkaba:~> fio /tmp/usb-stick.job           
> seq-read: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
> rand-read: (g=1): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio,
> iodepth=4 seq-write: (g=2): rw=write, bs=4K-4K/4K-4K, ioengine=libaio,
> iodepth=4 rand-write: (g=3): rw=randwrite, bs=4K-4K/4K-4K,
> ioengine=libaio, iodepth=4 2.0.8
> Starting 4 processes
> seq-read: Laying out IO file(s) (1 file(s) / 512MB)
> Jobs: 1 (f=1): [___w] [57.2% done] [0K/703K /s] [0 /175  iops] [eta
> 03m:00s]     seq-read: (groupid=0, jobs=1): err= 0: pid=7819
>   read : io=470600KB, bw=7843.8KB/s, iops=1960 , runt= 60002msec

I forgot the job file I used:

merkaba:~> cat /tmp/usb-stick.job 
[global]
bs=4k
ioengine=libaio
size=512m
direct=1
iodepth=4
runtime=60
directory=/mnt/zeit
filename=test.file

[seq-read]
rw=read
stonewall

[rand-read]
rw=randread
stonewall

[seq-write]
rw=write
stonewall

[rand-write]
rw=randwrite
stonewall

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
