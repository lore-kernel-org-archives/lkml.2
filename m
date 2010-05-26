Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0EZS7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:59:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36312 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab0EZS7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:59:13 -0400
Date: Wed, 26 May 2010 11:57:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] io-controller: Document for active bytes, time and
 rate.
Message-Id: <20100526115732.9701ac1b.randy.dunlap@oracle.com>
In-Reply-To: <4BF64883.5090201@cn.fujitsu.com>
References: <4BF64712.1070500@cn.fujitsu.com>
	<4BF64883.5090201@cn.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4BFD6F71.01A8:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 16:46:59 +0800 Gui Jianfeng wrote:

> Document for active bytes time and rate.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  Documentation/cgroups/blkio-controller.txt |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> index 48e0b21..2b015e8 100644
> --- a/Documentation/cgroups/blkio-controller.txt
> +++ b/Documentation/cgroups/blkio-controller.txt
> @@ -168,6 +168,27 @@ Details of cgroup files
>  	  cgroup. This is further divided by the type of operation - read or
>  	  write, sync or async.
>  
> +- blkio.io_active_bytes
> +	- Total number bytes transferred to/from the disk by the group since

	  Total number of bytes

> +	  the group got backlogged. First two fields specify the major and
> +	  minor number of the device, the third field specifies the operation
> +	  type and the fourth field specifies the number of bytes. It will be
> +	  reset when group gets dequeued from service tree.
> +
> +- blkio.io_active_time
> +	- Total amount of time(in ms) spent since the group got backlogged.

	                  time (in ms)

> +	  First two fields specify the major and minor number of the device,
> +	  third field specify how long it spents since the group got

	              specifies how long it spent

> +	  backlogged. It will be reset when group gets enqueued onto service
> +	  tree.
> +
> +- blkio.io_active_rate
> +	- The io rate (in bytes/ms) of the group when group is issuing io.

s/io/IO/ in multiple places (or s:io:I/O: if you prefer the '/')

> +	  First two fields specify the major and minor number of the device,
> +	  the third field specifies the operation type and the fourth field
> +	  specifies the io rate. If there isn't any io on the group, io rate
> +	  won't be computed.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
