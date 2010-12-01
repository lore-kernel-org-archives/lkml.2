Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab0LAHwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:52:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44259 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0LAHwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:52:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 1/3] mm: kswapd: Stop high-order balancing when any suitable zone is balanced
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Simon Kirby <sim@hostway.ca>, Dave Hansen <dave@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1291189227.12777.79.camel@sli10-conroe>
References: <20101201122638.ABBF.A69D9226@jp.fujitsu.com> <1291189227.12777.79.camel@sli10-conroe>
Message-Id: <20101201164647.ABD7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Dec 2010 16:52:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > we can't make
> > > > perfect VM heuristics obviously, then we need to compare pros/cons.
> > > if you don't care about small system, let's consider a NORMAL i386
> > > system with 896m normal zone, and 896M*3 high zone. normal zone will
> > > quickly exhaust by high order high zone allocation, leave a latter
> > > allocation which does need normal zone fail.
> > 
> > Not happen. slab don't allocate from highmem and page cache allocation
> > is always using order-0. When happen high order high zone allocation?
> ok, thanks, I missed this. then how about a x86_64 box with 896M DMA32
> and 896*3M NORMAL? some pci devices can only dma to DMA32 zone.

First, DMA32 is 4GB. Second, modern high end system don't use 32bit PCI
device. Third, while we are thinking desktop users, 4GB is not small
room. nowadays, typical desktop have only 2GB or 4GB memory.

In other word, I agree your pointed issue is exist _potentially_. but
I don't think it is frequently than Simon's case.

In other word, when deciding heuristics, we can't avoid to think issue
frequency. It's very important.


Of cource, if you have better idea, I don't oppose it.


