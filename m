Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab0DOJX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 05:23:58 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:53399 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753159Ab0DOJX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:23:56 -0400
Date: Thu, 15 Apr 2010 19:23:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Janos Haar <janos.haar@netcenter.hu>
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, xfs@oss.sgi.com,
       axboe@kernel.dk
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
 please!...)
Message-ID: <20100415092330.GU2493@dastard>
References: <20100408025822.GL11036@dastard>
 <11b701cad9c8$93212530$0400a8c0@dcccs>
 <20100412001158.GA2493@dastard>
 <18b101cadadf$5edbb660$0400a8c0@dcccs>
 <20100413083931.GW2493@dastard>
 <190201cadaeb$02ec22c0$0400a8c0@dcccs>
 <20100413113445.GZ2493@dastard>
 <1cd501cadb62$3a93e790$0400a8c0@dcccs>
 <20100414001615.GC2493@dastard>
 <233401cadc69$64c1f4f0$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <233401cadc69$64c1f4f0$0400a8c0@dcccs>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 09:00:49AM +0200, Janos Haar wrote:
> Dave,
> 
> The corruption + crash reproduced. (unfortunately)
> 
> http://download.netcenter.hu/bughunt/20100413/messages-15
> 
> Apr 14 01:06:33 alfa kernel: XFS mounting filesystem sdb2
> 
> This was the point of the xfs_repair more times.

OK, the inodes that are corrupted are different, so there's still
something funky going on here. I still would suggest replacing the
RAID controller to rule that out as the cause.

FWIW, do you have any other servers with similar h/w, s/w and
workloads? If so, are they seeing problems?

Can you recompile the kernel with CONFIG_XFS_DEBUG enabled and
reboot into it before you repair and remount the filesystem again?
(i.e. so that we know that we have started with a clean filesystem
and the debug kernel) I'm hoping that this will catch the corruption
much sooner, perhaps before it gets to disk. Note that this will
cause the machine to panic when corruption is detected, and it is
much,much more careful about checking in memory structures so there
is a CPU overhead involved as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
