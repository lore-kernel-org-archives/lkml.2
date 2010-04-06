Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0DFBWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 21:22:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:3968 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab0DFBWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 21:22:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,368,1267430400"; 
   d="scan'208";a="555219306"
Date: Tue, 6 Apr 2010 09:22:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Message-ID: <20100406012206.GD5295@localhost>
References: <20100331145602.03A7.A69D9226@jp.fujitsu.com> <20100401151639.a030fb10.akpm@linux-foundation.org> <20100402180812.646D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402180812.646D.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ===================================================================
> >From 52358cbccdfe94e0381974cd6e937bcc6b1c608b Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Fri, 2 Apr 2010 17:13:48 +0900
> Subject: [PATCH] Revert "vmscan: get_scan_ratio() cleanup"
> 
> Shaohua Li reported his tmpfs streaming I/O test can lead to make oom.
> The test uses a 6G tmpfs in a system with 3G memory. In the tmpfs,
> there are 6 copies of kernel source and the test does kbuild for each
> copy. His investigation shows the test has a lot of rotated anon
> pages and quite few file pages, so get_scan_ratio calculates percent[0]
> (i.e. scanning percent for anon)  to be zero. Actually the percent[0]
> shoule be a big value, but our calculation round it to zero.

  should      small :)

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks,
Fengguang
