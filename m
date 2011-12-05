Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1LEDao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 22:30:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:4221 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab1LEDan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 22:30:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="82848295"
Subject: Re: [PATCH 1/3] slub: set a criteria for slub node partial adding
From: "Alex,Shi" <alex.shi@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "cl@linux.com" <cl@linux.com>, "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1322825802.2607.10.camel@edumazet-laptop>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
	 <1322825802.2607.10.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 11:28:43 +0800
Message-ID: <1323055723.16790.138.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 19:36 +0800, Eric Dumazet wrote:
> Le vendredi 02 décembre 2011 à 16:23 +0800, Alex Shi a écrit :
> > From: Alex Shi <alexs@intel.com>
> > 
> > Times performance regression were due to slub add to node partial head
> > or tail. That inspired me to do tunning on the node partial adding, to
> > set a criteria for head or tail position selection when do partial
> > adding.
> > My experiment show, when used objects is less than 1/4 total objects
> > of slub performance will get about 1.5% improvement on netperf loopback
> > testing with 2048 clients, wherever on our 4 or 2 sockets platforms,
> > includes sandbridge or core2.
> > 
> > Signed-off-by: Alex Shi <alex.shi@intel.com>
> > ---
> >  mm/slub.c |   18 ++++++++----------
> >  1 files changed, 8 insertions(+), 10 deletions(-)
> > 
> 
> netperf (loopback or ethernet) is a known stress test for slub, and your
> patch removes code that might hurt netperf, but benefit real workload.
> 
> Have you tried instead this far less intrusive solution ?
> 
> if (tail == DEACTIVATE_TO_TAIL ||
>     page->inuse > page->objects / 4)
>          list_add_tail(&page->lru, &n->partial);
> else
>          list_add(&page->lru, &n->partial);

For loopback netperf, it has no clear performance change on all
platforms. 
For hackbench testing, it has a bit worse on 2P NHM 0.5~1%, but it is
helpful to increase about 2% on 4P(8cores * 2SMT) NHM machine. 

I was thought no much cache effect on hot or cold after per cpu partial
adding. but seems for hackbench, node partial still has much effect. 


> 
> 
> 


