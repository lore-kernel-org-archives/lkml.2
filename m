Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0C3GkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:40:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44386 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab0C3GkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:40:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>
In-Reply-To: <1269930756.17240.4.camel@sli10-desk.sh.intel.com>
References: <20100330150453.8E9F.A69D9226@jp.fujitsu.com> <1269930756.17240.4.camel@sli10-desk.sh.intel.com>
Message-Id: <20100330153750.8EA2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Mar 2010 15:40:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2010-03-30 at 14:08 +0800, KOSAKI Motohiro wrote:
> > Hi
> > 
> > > Commit 84b18490d1f1bc7ed5095c929f78bc002eb70f26 introduces a regression.
> > > With it, our tmpfs test always oom. The test has a lot of rotated anon
> > > pages and cause percent[0] zero. Actually the percent[0] is a very small
> > > value, but our calculation round it to zero. The commit makes vmscan
> > > completely skip anon pages and cause oops.
> > > An option is if percent[x] is zero in get_scan_ratio(), forces it
> > > to 1. See below patch.
> > > But the offending commit still changes behavior. Without the commit, we scan
> > > all pages if priority is zero, below patch doesn't fix this. Don't know if
> > > It's required to fix this too.
> > 
> > Can you please post your /proc/meminfo 
> attached.
> > and reproduce program? I'll digg it.
> our test is quite sample. mount tmpfs with double memory size and store several
> copies (memory size * 2/G) of kernel in tmpfs, and then do kernel build.
> for example, there is 3G memory and then tmpfs size is 6G and there is 6
> kernel copy.

Wow, tmpfs size > memsize!


> > Very unfortunately, this patch isn't acceptable. In past time, vmscan 
> > had similar logic, but 1% swap-out made lots bug reports. 
> can you elaborate this?
> Completely restore previous behavior (do full scan with priority 0) is
> ok too.

This is a option. but we need to know the root cause anyway. if not,
we might reintroduce this issue again in the future.



