Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1F3RlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:41:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab1F3RlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:41:17 -0400
Date: Thu, 30 Jun 2011 13:41:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jens Axboe <jaxboe@fusionio.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-cgroup: fix file names in documentation
Message-ID: <20110630174115.GH27889@redhat.com>
References: <1309447324-3824-1-git-send-email-andrea@betterlinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309447324-3824-1-git-send-email-andrea@betterlinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 05:22:04PM +0200, Andrea Righi wrote:
> All the blkio.throttle.* file names are incorrectly reported without
> ".throttle" in the documentation. Fix it.
> 
> Signed-off-by: Andrea Righi <andrea@betterlinux.com>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Good catch. I never noticed that "throttle" is missing in file names :-)

Thanks
Vivek

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
> 1.7.4.1
