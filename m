Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0EAPkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 11:40:09 -0400
Received: from xenotime.net ([72.52.115.56]:34340 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753227Ab0EAPkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 11:40:07 -0400
Date: Sat, 1 May 2010 08:40:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Bcache: version 4
Message-Id: <20100501084000.9c327ac5.rdunlap@xenotime.net>
In-Reply-To: <20100501001244.GB31135@moria>
References: <20100501001244.GB31135@moria>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010 16:12:44 -0800 Kent Overstreet wrote:

> diff --git a/block/Kconfig b/block/Kconfig
> index f9e89f4..0e5dbf2 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -100,6 +100,21 @@ config DEBUG_BLK_CGROUP
>  	in the blk group which can be used by cfq for tracing various
>  	group related activity.
>  
> +config BLK_CACHE
> +	tristate "Block device as cache"
> +	select SLOW_WORK
> +	default m
> +	---help---
> +	Allows a block device to be used as cache for other devices; uses
> +	a btree for indexing and the layout is optimized for SSDs.
> +
> +	Caches are persistent, and store the UUID of devices they cache.
> +	Hence, to open a device as cache, use
> +	"echo /dev/foo" > /sys/kernel/bcache/register_cache
> +	And to enable caching for a device
> +	"echo <UUID> /dev/foo" > /sys/kernel/bcache/register_dev

Aren't the quotation marks misplaced in these examples?


> +	See Documentation/bcache.txt for details.
> +
>  endif # BLOCK


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
