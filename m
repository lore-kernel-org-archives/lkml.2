Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1ELIYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 04:24:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34907 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1ELIYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 04:24:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 12 May 2011 17:17:25 +0900
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
Message-Id: <20110512171725.d367980f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110512132237.813a7c7f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110510190216.f4eefef7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110511182844.d128c995.akpm@linux-foundation.org>
	<20110512103503.717f4a96.kamezawa.hiroyu@jp.fujitsu.com>
	<20110511205110.354fa05e.akpm@linux-foundation.org>
	<20110512132237.813a7c7f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 13:22:37 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 11 May 2011 20:51:10 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:

> Ah, sorry. above was on KVM.  without container.
> ==
> [root@rhel6-test hilow]# time cp ./tmpfile xxx
> 
> real    0m5.197s
> user    0m0.006s
> sys     0m2.599s
> ==
> Hmm, still slow. I'll use real hardware in the next post.
> 

I'm now testing on a real machine with some fixes and see

== without async reclaim ==
real    0m6.569s
user    0m0.006s
sys     0m0.976s

== with async reclaim ==
real    0m6.305s
user    0m0.007s
sys     0m0.907s

...in gneral sys time reduced always but 'real' is in error range ;)
yes, no gain.

I'll check what codes in vmscan.c or /mm affects memcg and post a
required fix in step by step. I think I found some..

Thanks,
-Kame

