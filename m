Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab0DFBgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 21:36:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55508 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab0DFBgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 21:36:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>
In-Reply-To: <20100406012536.GB18672@sli10-desk.sh.intel.com>
References: <20100404231558.7E00.A69D9226@jp.fujitsu.com> <20100406012536.GB18672@sli10-desk.sh.intel.com>
Message-Id: <20100406103500.7E2D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Apr 2010 10:36:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Apr 04, 2010 at 10:19:06PM +0800, KOSAKI Motohiro wrote:
> > > On Fri, Apr 02, 2010 at 05:14:38PM +0800, KOSAKI Motohiro wrote:
> > > > > > > This patch makes a lot of sense than previous. however I think <1% anon ratio
> > > > > > > shouldn't happen anyway because file lru doesn't have reclaimable pages.
> > > > > > > <1% seems no good reclaim rate.
> > > > > > 
> > > > > > Oops, the above mention is wrong. sorry. only 1 page is still too big.
> > > > > > because under streaming io workload, the number of scanning anon pages should
> > > > > > be zero. this is very strong requirement. if not, backup operation will makes
> > > > > > a lot of swapping out.
> > > > > Sounds there is no big impact for the workload which you mentioned with the patch.
> > > > > please see below descriptions.
> > > > > I updated the description of the patch as fengguang suggested.
> > > > 
> > > > Umm.. sorry, no.
> > > > 
> > > > "one fix but introduce another one bug" is not good deal. instead, 
> > > > I'll revert the guilty commit at first as akpm mentioned.
> > > Even we revert the commit, the patch still has its benefit, as it increases
> > > calculation precision, right?
> > 
> > no, you shouldn't ignore the regression case.
> I don't think this is serious. In my calculation, there is only 1 page swapped out
> for 6G anonmous memory. 1 page should haven't any performance impact.

there is. I had received exactly opposite claim. because shrink_zone()
is not called only once. it is called very much time.




