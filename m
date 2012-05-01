Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab2EANvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:51:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43821 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab2EANvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:51:38 -0400
Date: Tue, 1 May 2012 14:47:42 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: avoid gratuitous BUG_ON in hugetlb_fault() ->
 hugetlb_cow()
Message-ID: <20120501134742.GA9004@csn.ul.ie>
References: <201204291936.q3TJa4Mv008924@farm-0027.internal.tilera.com>
 <alpine.LSU.2.00.1204301308090.2829@eggly.anvils>
 <20120501131413.GA11435@suse.de>
 <201205011333.q41DXsK7026759@farm-0013.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <201205011333.q41DXsK7026759@farm-0013.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 03:04:51PM -0400, Chris Metcalf wrote:
> Commit 66aebce747eaf added code to avoid a race condition by
> elevating the page refcount in hugetlb_fault() while calling
> hugetlb_cow().  However, one code path in hugetlb_cow() includes
> an assertion that the page count is 1, whereas it may now also
> have the value 2 in this path.  Consensus is that this BUG_ON
> has served its purpose, so rather than extending it to cover both
> cases, we just remove it.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
