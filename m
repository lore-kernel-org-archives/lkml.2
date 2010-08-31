Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab0HaXGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 19:06:30 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44797 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab0HaXG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 19:06:29 -0400
Subject: Re: [PATCH 01/10] Replace ioctls with sysfs interface
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1281374816-904-2-git-send-email-ngupta@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	 <1281374816-904-2-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 31 Aug 2010 16:06:23 -0700
Message-ID: <1283295983.7023.77.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 22:56 +0530, Nitin Gupta wrote:
> Creates per-device sysfs nodes in /sys/block/zram<id>/
> Currently following stats are exported:
>  - disksize
>  - num_reads
>  - num_writes
>  - invalid_io
>  - zero_pages
>  - orig_data_size
>  - compr_data_size
>  - mem_used_total
> 
> By default, disksize is set to 0. So, to start using
> a zram device, fist write a disksize value and then
> initialize device by writing any positive value to
> initstate. For example:
> 
>         # initialize /dev/zram0 with 50MB disksize
>         echo 50*1024*1024 | bc > /sys/block/zram0/disksize
>         echo 1 > /sys/block/zram0/initstate
> 
> When done using a disk, issue reset to free its memory
> by writing any positive value to reset node:
> 
>         echo 1 > /sys/block/zram0/reset

Maybe I'm just a weirdo, but I don't really use modules much.  That
effectively means that I'm stuck at boot with one zram device.

Making it a read-only module param also means that someone can't add a
second at runtime while the first is still in use.

It doesn't seem to be used very pervasively, but there is a
module_param_cb() function so you can register callbacks when the param
gets updated.  Might come in handy for this.

-- Dave

