Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab1DVRla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 13:41:30 -0400
Received: from trent.utfs.org ([194.246.123.103]:48618 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395Ab1DVRl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 13:41:29 -0400
Date: Fri, 22 Apr 2011 10:41:26 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Minchan Kim <minchan.kim@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, rientjes@google.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <BANLkTi=P5z4iON+ULiUEAeuuCJCJ_nMxWw@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1104221033220.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <BANLkTi=P5z4iON+ULiUEAeuuCJCJ_nMxWw@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011 at 11:58, Minchan Kim wrote:
> You would try to allocate a page from DMA as you don't have a normal zone.
> 
> Although free pages in DMA zone is about 3M, free pages of zone is
> below min of DMA zone. So zone_watermark_ok would be failed.
> 
> But I wonder why VM can't reclaim the pages. As I see the log, there
> are lots of slab pages(710M) in DMA zone while LRU pages are very
> small. SLAB pages are things VM has a trouble to reclaim. I am not
> sure 710M of SLAB is reasonable size. Don't you have experience same
> problem in old kernel?
> If you see the problem first in 2.6.39-rc4, maybe it would be a
> regression(ex, might be slab memory leak)
> Could you get the information about slabinfo(ex, cat /proc/slabinfo)
> right before OOM happens.
> It could say culprit.

It happened again, and again it's du(1) invoking the OOM killer (I'm 
running du(1) accross a few directories every 6hrs). This time I got 
/proc/slabinfo as well:

  http://nerdbynature.de/bits/2.6.39-rc4/oom/
  * NOTE: slabinfo.txt.gz deflates to ~40MB!)
  * messages-2.txt contains the messages of last night's OOM, which
   started at Apr 22 00:10:16 PDT

Thanks for looking into it.

Christian.
-- 
BOFH excuse #140:

LBNC (luser brain not connected)
