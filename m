Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0C3INp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:13:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:16432 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab0C3INm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:13:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,333,1267430400"; 
   d="scan'208";a="785057331"
Date: Tue, 30 Mar 2010 16:13:40 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Message-ID: <20100330081340.GA23691@sli10-desk.sh.intel.com>
References: <20100330153750.8EA2.A69D9226@jp.fujitsu.com>
 <20100330065358.GA24828@sli10-desk.sh.intel.com>
 <20100330160820.8EA8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330160820.8EA8.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 03:31:40PM +0800, KOSAKI Motohiro wrote:
> > > > > Very unfortunately, this patch isn't acceptable. In past time, vmscan 
> > > > > had similar logic, but 1% swap-out made lots bug reports. 
> > > > can you elaborate this?
> > > > Completely restore previous behavior (do full scan with priority 0) is
> > > > ok too.
> > > 
> > > This is a option. but we need to know the root cause anyway.
> > I thought I mentioned the root cause in first mail. My debug shows
> > recent_rotated[0] is big, but recent_rotated[1] is almost zero, which makes
> > percent[0] 0. But you can double check too.
> 
> To revert can save percent[0]==0 && priority==0 case. but it shouldn't
> happen, I think. It mean to happen big latency issue.
> 
> Can you please try following patch? Also, I'll prepare reproduce environment soon.
still oom with the patch.
