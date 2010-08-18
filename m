Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0HROsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:48:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37020 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab0HROsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:48:17 -0400
Date: Wed, 18 Aug 2010 20:18:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Per file dirty limit throttling
Message-ID: <20100818144809.GF28417@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <201008160949.51512.knikanth@suse.de>
 <201008171039.23701.knikanth@suse.de>
 <1282033475.1926.2093.camel@laptop>
 <201008181452.05047.knikanth@suse.de>
 <1282125536.1926.3675.camel@laptop>
 <20100818140856.GE28417@balbir.in.ibm.com>
 <1282141518.1926.4048.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1282141518.1926.4048.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-08-18 16:25:18]:

> On Wed, 2010-08-18 at 19:38 +0530, Balbir Singh wrote:
> 
> > There is an ongoing effort to look at per-cgroup dirty limits and I
> > honestly think it would be nice to do it at that level first. We need
> > it there as a part of the overall I/O controller. As a specialized
> > need it could handle your case as well. 
> 
> Well, it would be good to isolate that to the cgroup code. Also from
> what I understood, the plan was to simply mark dirty inodes with a
> cgroup and use that from writeout_inodes() to write out inodes
> specifically used by that cgroup.
> 
> That is, on top of what Andrea Righi already proposed, which would
> provide the actual per cgroup dirty limit (although the per-bdi
> proportions applied to a cgroup limit aren't strictly correct, but that
> seems to be something you'll have to live with, a per-bdi-per-cgroup
> proportion would simply be accounting insanity).
> 
> That is a totally different thing than what was proposed.

Understood, I was indirectly trying to get Nikanth to look at cgroups
since he was interested in the dirtier (as in task).


-- 
	Three Cheers,
	Balbir
