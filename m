Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab0D1Akq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 20:40:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41872 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0D1Akp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 20:40:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Apr 2010 09:36:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm,migration: Remove straggling migration PTEs when
 page tables are being moved after the VMA has already moved
Message-Id: <20100428093642.ca869815.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100428000833.GE510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
	<1272403852-10479-4-git-send-email-mel@csn.ul.ie>
	<20100428090302.5e69721f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100428000833.GE510@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 02:08:33 +0200
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Wed, Apr 28, 2010 at 09:03:02AM +0900, KAMEZAWA Hiroyuki wrote:
> > I bet calling __get_user_pages_fast() before vma_adjust() is the way to go. 
> > When page_count(page) != page_mapcount(page) +1, migration skip it.
> 
> My proposed fix avoids to walk the pagetables once more time and to
> mangle over the page counts. Can you check it? It works but it needs
> more review.

Sure...but can we avoid temporal objrmap breakage(inconsistency) by it ?

THanks,
-Kame

