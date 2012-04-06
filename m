Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2DFLhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 07:37:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36903 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2DFLhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 07:37:01 -0400
MIME-Version: 1.0
X-Originating-IP: [116.15.48.3]
In-Reply-To: <CAMVG2ss5WzwhgPunD5greRii1HFuEYt1TMQwxgUNitrpHtguVA@mail.gmail.com>
References: <CAMVG2ss5WzwhgPunD5greRii1HFuEYt1TMQwxgUNitrpHtguVA@mail.gmail.com>
Date: Fri, 6 Apr 2012 19:36:59 +0800
Message-ID: <CAMVG2st4VPbujSY1hH+VjbR1gxCR0ZEGznrObYMWnpgo++Ynug@mail.gmail.com>
Subject: [3.4-rc1] attempt to access beyond end of device and livelock
From: Daniel J Blueman <daniel@quora.org>
To: Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josef, Chris,

When testing BTRFS with RAID 0 metadata on linux-3.4-rc1, we see
discard ranges exceeding the end of the block device [1], potentially
causing dataloss; when this occurs, filesystem writeback becomes
catatonic due to continual resubmission.

Simply mounting with discard a raid0 metadata filesystem and copying
some data in [2] provokes the issue.

Thanks,
 Daniel

--- [1]

attempt to access beyond end of device
ram0: rw=129, want=8452072, limit=4096000
...

--- [2]

modprobe brd rd_size=2048000 (or boot with ramdisk_size=2048000)
mkfs.btrfs -m raid0 /dev/ram0 /dev/ram1
mount /dev/ram0 /mnt -o discard
cd /mnt && tar -xvzf linux.tar.gz
<access beyond end of device and livelock>
-- 
Daniel J Blueman
