Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab1F3RHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:07:05 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:59638 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751122Ab1F3RHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:07:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mniR4y/lnvVW8RkDruCzEzHBZRHRsJjX6taU7NHdAX62HT3Oh7zyAkakD0goXvPGz9mJi8PvUpK04ae6+2S8XCHPWYvg2nUWA1TewszjcoTcNvyHmffqU2LZAj5uQ9ag;
Date: Thu, 30 Jun 2011 10:06:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-cgroup: fix file names in documentation
Message-Id: <20110630100657.d2764892.rdunlap@xenotime.net>
In-Reply-To: <1309447324-3824-1-git-send-email-andrea@betterlinux.com>
References: <1309447324-3824-1-git-send-email-andrea@betterlinux.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 17:22:04 +0200 Andrea Righi wrote:

> All the blkio.throttle.* file names are incorrectly reported without
> ".throttle" in the documentation. Fix it.
> 
> Signed-off-by: Andrea Righi <andrea@betterlinux.com>

Applied, thanks.


> ---
>  Documentation/cgroups/blkio-controller.txt |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> index cd45c8e..84f0a15 100644
> --- a/Documentation/cgroups/blkio-controller.txt
> +++ b/Documentation/cgroups/blkio-controller.txt
> @@ -77,7 +77,7 @@ Throttling/Upper Limit policy
>  - Specify a bandwidth rate on particular device for root group. The format
>    for policy is "<major>:<minor>  <byes_per_second>".
>  
> -        echo "8:16  1048576" > /sys/fs/cgroup/blkio/blkio.read_bps_device
> +        echo "8:16  1048576" > /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device
>  
>    Above will put a limit of 1MB/second on reads happening for root group
>    on device having major/minor number 8:16.
> @@ -90,7 +90,7 @@ Throttling/Upper Limit policy
>          1024+0 records out
>          4194304 bytes (4.2 MB) copied, 4.0001 s, 1.0 MB/s
>  
> - Limits for writes can be put using blkio.write_bps_device file.
> + Limits for writes can be put using blkio.throttle.write_bps_device file.
>  
>  Hierarchical Cgroups
>  ====================
> @@ -286,28 +286,28 @@ Throttling/Upper limit policy files
>  	  specified in bytes per second. Rules are per deivce. Following is
>  	  the format.
>  
> -  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.read_bps_device
> +  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.read_bps_device
>  
>  - blkio.throttle.write_bps_device
>  	- Specifies upper limit on WRITE rate to the device. IO rate is
>  	  specified in bytes per second. Rules are per deivce. Following is
>  	  the format.
>  
> -  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.write_bps_device
> +  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.write_bps_device
>  
>  - blkio.throttle.read_iops_device
>  	- Specifies upper limit on READ rate from the device. IO rate is
>  	  specified in IO per second. Rules are per deivce. Following is
>  	  the format.
>  
> -  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.read_iops_device
> +  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.throttle.read_iops_device
>  
>  - blkio.throttle.write_iops_device
>  	- Specifies upper limit on WRITE rate to the device. IO rate is
>  	  specified in io per second. Rules are per deivce. Following is
>  	  the format.
>  
> -  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.write_iops_device
> +  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.throttle.write_iops_device
>  
>  Note: If both BW and IOPS rules are specified for a device, then IO is
>        subjectd to both the constraints.
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
