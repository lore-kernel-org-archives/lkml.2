Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0H0BvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 21:51:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:38481 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab0H0BvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 21:51:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,277,1280732400"; 
   d="scan'208";a="832327167"
Date: Fri, 27 Aug 2010 09:50:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [RFC PATCH 0/3] Do not wait the full timeout on
 congestion_wait when there is no congestion
Message-ID: <20100827015041.GF7353@localhost>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
 <20100826172038.GA6873@barrios-desktop>
 <20100827012147.GC7353@localhost>
 <AANLkTimLhZcP=eqB9TFfO_rgb-dhXUJh8iNTXuceuCq0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimLhZcP=eqB9TFfO_rgb-dhXUJh8iNTXuceuCq0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 09:41:48AM +0800, Minchan Kim wrote:
> Hi, Wu.
> 
> On Fri, Aug 27, 2010 at 10:21 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > Minchan,
> >
> > It's much cleaner to keep the unchanged congestion_wait() and add a
> > congestion_wait_check() for converting problematic wait sites. The
> > too_many_isolated() wait is merely a protective mechanism, I won't
> > bother to improve it at the cost of more code.
> 
> You means following as?

No, I mean do not change the too_many_isolated() related code at all :)
And to use congestion_wait_check() in other places that we can prove
there is a problem that can be rightly fixed by changing to
congestion_wait_check().

>         while (unlikely(too_many_isolated(zone, file, sc))) {
>                 congestion_wait_check(BLK_RW_ASYNC, HZ/10);
> 
>                 /* We are about to die and free our memory. Return now. */
>                 if (fatal_signal_pending(current))
>                         return SWAP_CLUSTER_MAX;
>         }

Thanks,
Fengguang
