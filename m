Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2DHIuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 04:50:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16625 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab2DHIuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 04:50:22 -0400
X-IronPort-AV: E=Sophos;i="4.75,389,1330876800"; 
   d="scan'208";a="4704889"
Message-ID: <4F81510B.60406@cn.fujitsu.com>
Date: Sun, 08 Apr 2012 16:49:15 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Daniel J Blueman <daniel@quora.org>
CC: Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc1] attempt to access beyond end of device and livelock
References: <CAMVG2ss5WzwhgPunD5greRii1HFuEYt1TMQwxgUNitrpHtguVA@mail.gmail.com> <CAMVG2st4VPbujSY1hH+VjbR1gxCR0ZEGznrObYMWnpgo++Ynug@mail.gmail.com>
In-Reply-To: <CAMVG2st4VPbujSY1hH+VjbR1gxCR0ZEGznrObYMWnpgo++Ynug@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/08 16:49:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/08 16:49:53,
	Serialize complete at 2012/04/08 16:49:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 07:36 PM, Daniel J Blueman wrote:
> Hi Josef, Chris,
> 
> When testing BTRFS with RAID 0 metadata on linux-3.4-rc1, we see
> discard ranges exceeding the end of the block device [1], potentially
> causing dataloss; when this occurs, filesystem writeback becomes
> catatonic due to continual resubmission.
> 
> Simply mounting with discard a raid0 metadata filesystem and copying
> some data in [2] provokes the issue.
> 
> Thanks,
>  Daniel
> 
> --- [1]
> 
> attempt to access beyond end of device
> ram0: rw=129, want=8452072, limit=4096000
> ...
> 
> --- [2]
> 
> modprobe brd rd_size=2048000 (or boot with ramdisk_size=2048000)
> mkfs.btrfs -m raid0 /dev/ram0 /dev/ram1
> mount /dev/ram0 /mnt -o discard
> cd /mnt && tar -xvzf linux.tar.gz
> <access beyond end of device and livelock>

Thanks for the report, this bug shows we've miscalculated the length of discard extents.

I'll send a patch for this soon.

thanks,
-- 
liubo 
