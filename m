Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab2GRHQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 03:16:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:44080 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab2GRHQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 03:16:04 -0400
Message-ID: <1342595730.3669.70.camel@pasglop>
Subject: Re: [PATCH] mm: setup pageblock_order before it's used by sparse
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Tony Luck <tony.luck@intel.com>,
        Xishi Qiu <qiuxishi@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org
Date: Wed, 18 Jul 2012 17:15:30 +1000
In-Reply-To: <CAE9FiQVxY9E3L_xmRj10+9D6NVbKaxaAd2oJ6EFe1D+Gy2971w@mail.gmail.com>
References: <1341047274-5616-1-git-send-email-jiang.liu@huawei.com>
	 <CAE9FiQWzfLkeQs8O22MUEmuGUx=jPi5s=wZt2fcpFMcwrzt3uA@mail.gmail.com>
	 <4FF100F0.9050501@huawei.com>
	 <CAE9FiQXpeGFfWvUHHW_GjgTg+4Op7agsht5coZbcmn2W=f9bqw@mail.gmail.com>
	 <4FF25EFA.1080004@huawei.com>
	 <CAE9FiQVxY9E3L_xmRj10+9D6NVbKaxaAd2oJ6EFe1D+Gy2971w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 20:25 -0700, Yinghai Lu wrote:
> > That means pageblock_order is always set to "MAX_ORDER - 1", not sure
> > whether this is intended. And it has the same issue as IA64 of wasting
> > memory if CONFIG_SPARSE is enabled.
> 
> adding BenH, need to know if it is powerpc intended.
> 
> >
> > So it would be better to keep function set_pageblock_order(), it will
> > fix the memory wasting on both IA64 and PowerPC.
> 
> Should setup pageblock_order as early as possible to avoid confusing.

Hrm, HPAGE_SHIFT is initially 0 because we only know at runtime what
huge page sizes are going to be supported (if any).

The business with pageblock_order is new to me and does look bogus today
indeed. But not a huge deal either. Our MAX_ORDER is typically 9 (64K
pages) or 13 (4K pages) and our standard huge page size is generally 16M
so there isn't a big difference here.

Still, maybe something worth looking into...

Cheers,
Ben.


