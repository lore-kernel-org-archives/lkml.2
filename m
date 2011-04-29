Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab1D2C6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 22:58:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:25568 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758397Ab1D2C6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 22:58:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,284,1301900400"; 
   d="scan'208";a="739999644"
Date: Fri, 29 Apr 2011 10:58:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Dave Chinner <david@fromorbit.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC][PATCH] mm: cut down __GFP_NORETRY page allocation
 failures
Message-ID: <20110429025838.GA13150@localhost>
References: <BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
 <BANLkTim0MNgqeh1KTfvpVFuAvebKyQV8Hg@mail.gmail.com>
 <20110426062535.GB19717@localhost>
 <BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
 <20110426063421.GC19717@localhost>
 <BANLkTi=xDozFNBXNdGDLK6EwWrfHyBifQw@mail.gmail.com>
 <20110426092029.GA27053@localhost>
 <20110426124743.e58d9746.akpm@linux-foundation.org>
 <20110428133644.GA12400@localhost>
 <20110429022824.GA8061@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429022824.GA8061@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I tested the more realistic 100 dd case. The results are

- nr_alloc_fail: 892 => 146
- reclaim delay: 4ms => 68ms

Thanks,
Fengguang
---

base kernel, 100 dd
-------------------

start time: 3
total time: 52
nr_alloc_fail 892
allocstall 131341

2nd run (no reboot):

start time: 3
total time: 53
nr_alloc_fail 1555
allocstall 265718


CPU             count     real total  virtual total    delay total
                  962     3125524848     3113269116    37972729582
IO              count    delay total  delay average
                    3       25204838              8ms
SWAP            count    delay total  delay average
                    0              0              0ms
RECLAIM         count    delay total  delay average    
                 1032     5130797747              4ms  

(IPIs accumulated in two runs)
CAL:      34898      35428      35182      35553      35320      35291      35298      35102   Function call interrupts

10ms limit, 100 dd
------------------

start time: 2
total time: 50
nr_alloc_fail 146
allocstall 10598

CPU             count     real total  virtual total    delay total
                 1038     3349490800     3331087137    40156395960
IO              count    delay total  delay average
                    0              0              0ms
SWAP            count    delay total  delay average
                    0              0              0ms
RECLAIM         count    delay total  delay average
                   84     5795410854             68ms
dd: read=0, write=0, cancelled_write=0

Thanks,
Fengguang
