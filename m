Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2BYAGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 19:06:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:12898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab2BYAGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 19:06:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="111691472"
Subject: Re: [PATCH v3 00/21] mm: lru_lock splitting
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20120223133728.12988.5432.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 16:05:53 -0800
Message-ID: <1330128354.13358.43.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 17:51 +0400, Konstantin Khlebnikov wrote:
> v3 changes:
> * inactive-ratio reworked again, now it always calculated from from scratch
> * hierarchical pte reference bits filter in memory-cgroup reclaimer
> * fixed two bugs in locking, found by Hugh Dickins
> * locking functions slightly simplified
> * new patch for isolated pages accounting
> * new patch with lru interleaving
> 
> This patchset is based on next-20120210
> 
> git: https://github.com/koct9i/linux/commits/lruvec-v3
> 
> ---

I am seeing an improvement of about 7% in throughput in a workload where
I am doing parallel reading of files that are mmaped. The contention on
lru_lock used to be 13% in the cpu profile on the __pagevec_lru_add code
path. Now lock contention on this path drops to about 0.6%.  I have 40
hyper-threaded enabled cpu cores running 80 mmaped file reading
processes.

So initial testing of this patch set looks encouraging.

Tim

