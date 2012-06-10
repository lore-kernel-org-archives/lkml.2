Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2FJDQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 23:16:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:50239 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab2FJDQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 23:16:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163673063"
Date: Sun, 10 Jun 2012 11:16:34 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, gaofeng@cn.fujitsu.com,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] inet: Initialize per-netns inetpeer roots in
 net/ipv{4,6}/route.c
Message-ID: <20120610031634.GA10032@localhost>
References: <20120609.163202.516027044484907548.davem@davemloft.net>
 <20120610015832.GA9175@localhost>
 <20120609.190451.182034193302304295.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120609.190451.182034193302304295.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2012 at 07:04:51PM -0700, David Miller wrote:
> From: Fengguang Wu <wfg@linux.intel.com>
> Date: Sun, 10 Jun 2012 09:58:32 +0800
> 
> > It triggers some warnings:
> > 
> > WARNING: net/ipv6/ipv6.o(.text+0x1049c): Section mismatch in reference from the function ip6_route_cleanup() to the variable .init.data:ipv6_inetpeer_ops
> 
> This should fix it:

Yes it worked.

Tested-by: Fengguang Wu <wfg@linux.intel.com>

In long run, such build-fix patches can also be auto tested and
reported, somehow in this way. You just create a temporary branch
named "0day-XXXXXX" and push the build-fix patch there. After a while
my robot script will pull and build test it. When finished, it will
recognize the "0day" pattern in the branch name and then
*unconditionally* report back.

"unconditionally" means it will

- report build failure as well as build success
- report new error/warnings as well as old ones

Upon receiving the success/failure notification, you can then proceed
to either merge the commit to the main branch, or update the commit in
place to restart the test. This should work much more fluently than
waiting for me to manually test some emailed patch. Not only I may be
sleeping at the time, but also I'm sending out build failure reports
almost *every day*. It would be a burden for me to manually test out
fixes every day...

Thanks,
Fengguang
