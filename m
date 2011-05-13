Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1EMDKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 23:10:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60681 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1EMDKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 23:10:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 13 May 2011 12:03:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>, Johannes Weiner <jweiner@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 0/7] memcg async reclaim
Message-Id: <20110513120318.63ff7d0e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110512171725.d367980f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110510190216.f4eefef7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110511182844.d128c995.akpm@linux-foundation.org>
	<20110512103503.717f4a96.kamezawa.hiroyu@jp.fujitsu.com>
	<20110511205110.354fa05e.akpm@linux-foundation.org>
	<20110512132237.813a7c7f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110512171725.d367980f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 17:17:25 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 12 May 2011 13:22:37 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> I'll check what codes in vmscan.c or /mm affects memcg and post a
> required fix in step by step. I think I found some..
> 

After some tests, I doubt that 'automatic' one is unnecessary until
memcg's dirty_ratio is supported. And as Andrew pointed out,
total cpu consumption is unchanged and I don't have workloads which
shows me meaningful speed up.
But I guess...with dirty_ratio, amount of dirty pages in memcg is
limited and background reclaim can work enough without noise of
write_page() while applications are throttled by dirty_ratio.

Hmm, I'll study for a while but it seems better to start active soft limit,
(or some threshold users can set) first. 

Anyway, this work makes me to see vmscan.c carefully and I think I can
post some patches for fix, tunes.

Thanks,
-Kame

