Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab1CDIBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:01:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45211 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067Ab1CDIBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:01:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Mar 2011 16:54:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Poelzleithner <poelzi@poelzi.org>, linux-mm@kvack.org,
        containers@lists.linux-foundation.org
Subject: Re: cgroup memory, blkio and the lovely swapping
Message-Id: <20110304165455.d438342a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110304083944.22fb612f@sol>
References: <20110304083944.22fb612f@sol>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011 08:39:44 +0100
Daniel Poelzleithner <poelzi@poelzi.org> wrote:

> Hi,
> 
> currently when one process causes heavy swapping, the responsiveness of
> the hole system suffers greatly. With the small memleak [1] test tool I
> wrote, the effect can be experienced very easily, depending on the
> delay the lag can become quite large. If I ensure that 10% of the RAM
> stay free for free memory and cache, the system never swaps to death.
> That works very well, but if accesses to the swap are very heavy, the
> system still lags on all other processes, not only the swapping one.
> Putting the swapping process into a blkio cgroup with little weight does
> not affect the io or swap io from other processes with larger weight in
> their group.
> 
> Maybe I'm mistaken, but wouldn't it be the easiest way to get fair
> swapping and control to let the pagein respect the blkio.weight value
> or even better add a second weight value for swapping io ?
> 

Now, blkio cgroup does work only with synchronous I/O(direct I/O)
and never work with swap I/O. And I don't think swap-i/o limit
is a blkio matter.

Memory cgroup is now developping dirty_ratio for memory cgroup.
By that, you can control the number of pages in writeback, in memory cgroup.
I think it will work for you.

Thanks,
-Kame

