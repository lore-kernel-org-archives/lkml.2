Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1AaAFC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 19:05:02 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57971 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1AaAFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 19:05:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 Jan 2011 08:58:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, balbir@linux.vnet.ibm.com,
        linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH 3/3] Provide control over unmapped pages (v4)
Message-Id: <20110131085853.b09aef2d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1101280917570.1194@router.home>
References: <20110125051003.13762.35120.stgit@localhost6.localdomain6>
	<20110125051015.13762.13429.stgit@localhost6.localdomain6>
	<AANLkTikHLw0Qg+odOB-bDtBSB-5UbTJ5ZOM-ZAdMqXgh@mail.gmail.com>
	<AANLkTi=qXsDjN5Jp4m3QMgVnckoAM7uE9_Hzn6CajP+c@mail.gmail.com>
	<AANLkTinfxXc04S9VwQcJ9thFff=cP=icroaiVLkN-GeH@mail.gmail.com>
	<20110128064851.GB5054@balbir.in.ibm.com>
	<AANLkTikw_j0JJVqEsj1xThoashiOARg+8BgcLKrvkV3U@mail.gmail.com>
	<20110128165605.3cbe5208.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1101280917570.1194@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 09:20:02 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> On Fri, 28 Jan 2011, KAMEZAWA Hiroyuki wrote:
> 
> > > > I see it as a tradeoff of when to check? add_to_page_cache or when we
> > > > are want more free memory (due to allocation). It is OK to wakeup
> > > > kswapd while allocating memory, somehow for this purpose (global page
> > > > cache), add_to_page_cache or add_to_page_cache_locked does not seem
> > > > the right place to hook into. I'd be open to comments/suggestions
> > > > though from others as well.
> >
> > I don't like add hook here.
> > AND I don't want to run kswapd because 'kswapd' has been a sign as
> > there are memory shortage. (reusing code is ok.)
> >
> > How about adding new daemon ? Recently, khugepaged, ksmd works for
> > managing memory. Adding one more daemon for special purpose is not
> > very bad, I think. Then, you can do
> >  - wake up without hook
> >  - throttle its work.
> >  - balance the whole system rather than zone.
> >    I think per-node balance is enough...
> 
> 
> I think we already have enough kernel daemons floating around. They are
> multiplying in an amazing way. What would be useful is to map all
> the memory management background stuff into a process. May call this memd
> instead? Perhaps we can fold khugepaged into kswapd as well etc.
> 

Making kswapd slow for whis "additional", "requested by user, not by system"
work is good thing ? I think workqueue works enough well, it's scale based on
workloads, if using thread is bad.

Thanks,
-Kame




