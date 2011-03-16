Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab1CPAHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 20:07:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57375 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab1CPAHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:07:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Mar 2011 09:00:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mike Heffner <mike@librato.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>,
        Andrea Righi <arighi@develer.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 6/9] memcg: add cgroupfs interface to memcg dirty
 limits
Message-Id: <20110316090042.e1f0183b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4D7F7121.5040009@librato.com>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
	<1299869011-26152-7-git-send-email-gthelen@google.com>
	<4D7F7121.5040009@librato.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 10:01:05 -0400
Mike Heffner <mike@librato.com> wrote:

> On 03/11/2011 01:43 PM, Greg Thelen wrote:
> > Add cgroupfs interface to memcg dirty page limits:
> >    Direct write-out is controlled with:
> >    - memory.dirty_ratio
> >    - memory.dirty_limit_in_bytes
> >
> >    Background write-out is controlled with:
> >    - memory.dirty_background_ratio
> >    - memory.dirty_background_limit_bytes
> 
> 
> What's the overlap, if any, with the current memory limits controlled by 
> `memory.limit_in_bytes` and the above `memory.dirty_limit_in_bytes`? If 
> I want to fairly balance memory between two cgroups be one a dirty page 
> antagonist (dd) and the other an anonymous page (memcache), do I just 
> set `memory.limit_in_bytes`? Does this patch simply provide a more 
> granular level of control of the dirty limits?
> 

dirty_ratio is for control
 - speed of write() within cgroup.
 - risk of huge latency at memory reclaim (and OOM)
   Small dirty ratio means big ratio of clean page within cgroup.
   This will make memory reclaim, pageout easier.

memory.limit_in_bytes controls the amount of memory.

Thanks,
-Kame

