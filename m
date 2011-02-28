Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983Ab1B1GAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:00:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39381 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1B1GAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:00:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Feb 2011 14:54:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: compaction: Minimise the time IRQs are disabled
 while isolating pages for migration
Message-Id: <20110228145402.65e6f200.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110228054818.GF22700@random.random>
References: <1298664299-10270-1-git-send-email-mel@csn.ul.ie>
	<1298664299-10270-3-git-send-email-mel@csn.ul.ie>
	<20110228111746.34f3f3e0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110228054818.GF22700@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011 06:48:18 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Mon, Feb 28, 2011 at 11:17:46AM +0900, KAMEZAWA Hiroyuki wrote:
> > BTW, I forget why we always take zone->lru_lock with IRQ disabled....
> 
> To decrease lock contention in SMP to deliver overall better
> performance (not sure how much it helps though). It was supposed to be
> hold for a very short time (PAGEVEC_SIZE) to avoid giving irq latency
> problems.
> 

memory hotplug uses MIGRATE_ISOLATED migrate types for scanning pfn range
without lru_lock. I wonder whether we can make use of it (the function
which memory hotplug may need rework for the compaction but  migrate_type can
be used, I think).

Hmm.
-Kame

