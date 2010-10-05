Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0JEEuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 00:50:46 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39564 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab0JEEup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 00:50:45 -0400
Date: Tue, 5 Oct 2010 10:20:23 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 00/10] memcg: per cgroup dirty page accounting
Message-ID: <20101005045023.GS7896@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1286175485-30643-1-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Thelen <gthelen@google.com> [2010-10-03 23:57:55]:

> This patch set provides the ability for each cgroup to have independent dirty
> page limits.
> 
> Limiting dirty memory is like fixing the max amount of dirty (hard to reclaim)
> page cache used by a cgroup.  So, in case of multiple cgroup writers, they will
> not be able to consume more than their designated share of dirty pages and will
> be forced to perform write-out if they cross that limit.
> 
> These patches were developed and tested on mmotm 2010-09-28-16-13.  The patches
> are based on a series proposed by Andrea Righi in Mar 2010.

Hi, Greg,

I see a problem with "    memcg: add dirty page accounting infrastructure".

The reject is

 enum mem_cgroup_write_page_stat_item {
        MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
+       MEMCG_NR_FILE_DIRTY, /* # of dirty pages in page cache */
+       MEMCG_NR_FILE_WRITEBACK, /* # of pages under writeback */
+       MEMCG_NR_FILE_UNSTABLE_NFS, /* # of NFS unstable pages */
 };

I don't see mem_cgroup_write_page_stat_item in memcontrol.h. Is this
based on top of Kame's cleanup.

I am working off of mmotm 28 sept 2010 16:13.


-- 
	Three Cheers,
	Balbir
