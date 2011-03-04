Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab1CDILl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:11:41 -0500
Received: from quamquam.org ([88.198.196.3]:52398 "EHLO quamquam.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab1CDILk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:11:40 -0500
Date: Fri, 4 Mar 2011 09:11:32 +0100
From: Daniel Poelzleithner <poelzi@poelzi.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.linux-foundation.org
Message-ID: <20110304091132.6de2ed94@sol>
In-Reply-To: <20110304165455.d438342a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110304083944.22fb612f@sol>
	<20110304165455.d438342a.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 194.77.75.60
X-SA-Exim-Rcpt-To: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, containers@lists.linux-foundation.org
X-SA-Exim-Mail-From: poelzi@poelzi.org
Subject: Re: cgroup memory, blkio and the lovely swapping
X-SA-Exim-Version: 4.2.1 (built Sat, 07 Nov 2009 20:03:47 +0000)
X-SA-Exim-Scanned: Yes (on quamquam.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011 16:54:55 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Now, blkio cgroup does work only with synchronous I/O(direct I/O)
> and never work with swap I/O. And I don't think swap-i/o limit
> is a blkio matter.

I'm totally unsure about what subsystem it really belongs to. It is
memory for sure, but disk access, which it actually affects, belongs to
the blkio subsystem. Is there a technical reason why swap I/O is not run
through the blkio system ?


> Memory cgroup is now developping dirty_ratio for memory cgroup.
> By that, you can control the number of pages in writeback, in memory
> cgroup. I think it will work for you.

I'm not sure that fixes the fairness problem on swapio. Just having a
larger buffer before a writeback happens will reduce seeks, but not
give fair share of io in swap in. It's good to control over it on
cgroup level, but i doubt it will fix the problem.



kind regards
 Daniel

