Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab0HaWim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 18:38:42 -0400
Received: from kroah.org ([198.145.64.141]:41278 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab0HaWik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 18:38:40 -0400
Date: Tue, 31 Aug 2010 15:37:39 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] zram: various improvements and cleanups
Message-ID: <20100831223739.GA345@kroah.com>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281374816-904-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 10:56:46PM +0530, Nitin Gupta wrote:
> The zram module creates RAM based block devices named /dev/zram<id>
> (<id> = 0, 1, ...). Pages written to these disks are compressed and stored
> in memory itself.
> 
> One of the major changes done is the replacement of ioctls with sysfs
> interface. One of the advantages of this approach is we no longer depend on the
> userspace tool (rzscontrol) which was used to set various parameters and check
> statistics. Maintaining updated version of rzscontrol as changes were done to
> ioctls, statistics exported etc. was a major pain.
> 
> Another significant change is the introduction of percpu stats and compression
> buffers. Earlier, we had per-device buffers protected by a mutex. This was a
> major bottleneck on multi-core systems. With these changes, benchmarks with
> fio[1] showed a speedup of about 20% for write performance on dual-core
> system (see patch 4/10 description for details).
> 
> 
> For easier testing, a single patch against 2.6.35-git8 has been uploaded at:
> http://compcache.googlecode.com/hg/sub-projects/mainline/zram_2.6.36-rc0.patch

I applied the first 2 and last 2 of these patches and they will show up
in the linux-next tree tomorrow.  I stopped there due to Andrew's
complaints about the per-cpu variable stuff.  Please resolve this and
redo the patch set and I will be glad to apply them.

thanks,

greg k-h
