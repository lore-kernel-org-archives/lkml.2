Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0KRJQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:16:32 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49669 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab0KRJQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:16:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Nov 2010 18:10:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] mm: compaction: Use the LRU to get a hint on where
 compaction should start
Message-Id: <20101118181048.7bdfbb38.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1290010969-26721-8-git-send-email-mel@csn.ul.ie>
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie>
	<1290010969-26721-8-git-send-email-mel@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 16:22:48 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> The end of the LRU stores the oldest known page. Compaction on the other
> hand always starts scanning from the start of the zone. This patch uses
> the LRU to hint to compaction where it should start scanning from. This
> means that compaction will at least start with some old pages reducing
> the impact on running processes and reducing the amount of scanning. The
> check it makes is racy as the LRU lock is not taken but it should be
> harmless as we are not manipulating the lists without the lock.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Hmm, does this patch make a noticable difference ?
Isn't it better to start scan from the biggest free chunk in a zone ?

Thanks,
-Kame

