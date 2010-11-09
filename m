Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0KIMPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:15:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:22216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569Ab0KIMPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:15:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="855692522"
Date: Tue, 9 Nov 2010 20:15:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] memcg: make mem_cgroup_page_stat() return value
 unsigned
Message-ID: <20101109121508.GA2764@localhost>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
 <1289294671-6865-7-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289294671-6865-7-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 05:24:31PM +0800, Greg Thelen wrote:
> mem_cgroup_page_stat() used to return a negative page count
> value to indicate value.
> 
> mem_cgroup_page_stat() has changed so it never returns
> error so convert the return value to the traditional page
> count type (unsigned long).
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---

> +	/*
> +	 * The sum of unlocked per-cpu counters may yield a slightly negative
> +	 * value.  This function returns an unsigned value, so round it up to
> +	 * zero to avoid returning a very large value.
> +	 */
> +	if (value < 0)
> +		value = 0;

nitpick: it's good candidate for unlikely().

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

Sorry, I lose track to the source code after so many patches.
It would help if you can put the patches to a git tree.

Thanks,
Fengguang
