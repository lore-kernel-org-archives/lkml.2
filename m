Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab2CHFhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 00:37:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60645 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2CHFhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 00:37:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Mar 2012 14:36:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] mm/memcg: rework inactive_ratio calculation
Message-Id: <20120308143619.4f25880e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4F50678C.6010800@openvz.org>
References: <20120229090748.29236.35489.stgit@zurg>
	<20120229091600.29236.69514.stgit@zurg>
	<20120302143106.d4238cda.kamezawa.hiroyu@jp.fujitsu.com>
	<4F50678C.6010800@openvz.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2012 10:24:12 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Wed, 29 Feb 2012 13:16:00 +0400
> > Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
> >
> >> This patch removes precalculated zone->inactive_ratio.
> >> Now it always calculated in inactive_anon_is_low() from current lru size.
> >> After that we can merge memcg and non-memcg cases and drop duplicated code.
> >>
> >> We can drop precalculated ratio, because its calculation fast enough to do it
> >> each time. Plus precalculation uses zone size as basis, this estimation not
> >> always match with page lru size, for example if a significant proportion
> >> of memory occupied by kernel objects.om memory cgroup which is triggered this memory reclaim.
> This is more reason
> >>
> >> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> >
> > Maybe good....but please don't change the user interface /proc/zoneinfo implicitly.
> > How about calculating inactive_ratio at reading /proc/zoneinfo ?
> 
> I don't know... Anybody need this?

I don't like changes in user interface without any caution in feature-removal-schedule.txt
I just don't Ack. If others say ok, please go ahead with them.

Thanks,
-Kame

