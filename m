Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab1CIFng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 00:43:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53764 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab1CIFnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 00:43:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Mar 2011 14:37:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrew Vagin <avagin@gmail.com>,
        Andrey Vagin <avagin@openvz.org>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in
 all_unreclaimable()
Message-Id: <20110309143704.194e8ee1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTinDhorLusBju=Gn3bh1VsH1jrv0qixbU3SGWiqa@mail.gmail.com>
References: <1299325456-2687-1-git-send-email-avagin@openvz.org>
	<20110305152056.GA1918@barrios-desktop>
	<4D72580D.4000208@gmail.com>
	<20110305155316.GB1918@barrios-desktop>
	<4D7267B6.6020406@gmail.com>
	<20110305170759.GC1918@barrios-desktop>
	<20110307135831.9e0d7eaa.akpm@linux-foundation.org>
	<AANLkTinDhorLusBju=Gn3bh1VsH1jrv0qixbU3SGWiqa@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011 08:45:51 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Tue, Mar 8, 2011 at 6:58 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sun, 6 Mar 2011 02:07:59 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> > Any alternative proposals?  We should get the livelock fixed if possible..
> >
> 
> And we should avoid unnecessary OOM kill if possible.
> 
> I think the problem is caused by (zone->pages_scanned <
> zone_reclaimable_pages(zone) * 6). I am not sure (* 6) is a best. It
> would be rather big on recent big DRAM machines.
> 

It means 3 times full-scan from the highest priority to the lowest
and cannot freed any pages. I think big memory machine tend to have
more cpus, so don't think it's big.

> I think it is a trade-off between latency and OOM kill.
> If we decrease the magic value, maybe we should prevent the almost
> livelock but happens unnecessary OOM kill.
> 

Hmm, should I support a sacrifice feature 'some signal(SIGINT?) will be sent by
the kernel when it detects system memory is in short' in cgroup ?
(For example, if full LRU scan is done in a zone, notifier
 works and SIGINT will be sent.)

> And I think zone_reclaimable not fair.
> For example, too many scanning makes reclaimable state to
> unreclaimable state. Maybe it takes a very long time. But just some
> page free makes unreclaimable state to reclaimabe with very easy. So
> we need much painful reclaiming for changing reclaimable state with
> unreclaimabe state. it would affect latency very much.
> 
> Maybe we need more smart zone_reclaimabe which is adaptive with memory pressure.
> 
I agree.

Thanks,
-Kame

