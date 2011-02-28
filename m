Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab1B1Xsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:48:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34497 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab1B1Xsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:48:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Mar 2011 08:42:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: compaction: Minimise the time IRQs are disabled
 while isolating pages for migration
Message-Id: <20110301084209.2cfbd063.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110228101827.GE9548@csn.ul.ie>
References: <1298664299-10270-1-git-send-email-mel@csn.ul.ie>
	<1298664299-10270-3-git-send-email-mel@csn.ul.ie>
	<20110228111746.34f3f3e0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110228054818.GF22700@random.random>
	<20110228145402.65e6f200.kamezawa.hiroyu@jp.fujitsu.com>
	<20110228092814.GC9548@csn.ul.ie>
	<20110228184230.7c2eefb7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110228101827.GE9548@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011 10:18:27 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> > BTW, can't we drop disable_irq() from all lru_lock related codes ?
> > 
> 
> I don't think so - at least not right now. Some LRU operations such as LRU
> pagevec draining are run from IPI which is running from an interrupt so
> minimally spin_lock_irq is necessary.
> 

pagevec draining is done by workqueue(schedule_on_each_cpu()). 
I think only racy case is just lru rotation after writeback.

Thanks,
-Kame

