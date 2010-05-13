Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab0EMQOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:14:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49526 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223Ab0EMQOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:14:23 -0400
Date: Thu, 13 May 2010 18:14:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/7] hugetlb, rmap: add reverse mapping for hugepage
Message-ID: <20100513161415.GC28226@basil.fritz.box>
References: <1273737326-21211-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1273737326-21211-2-git-send-email-n-horiguchi@ah.jp.nec.com> <20100513152737.GE27949@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513152737.GE27949@csn.ul.ie>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think what you're getting with this is the ability to unmap MAP_PRIVATE pages
> from one process but if there are multiple processes, the second process could
> still end up referencing the poisoned MAP_PRIVATE page. Is this accurate? Even
> if it is, I guess it's still an improvement over what currently happens.

The only real requirement is that all PTEs pointing to that page 
get replaced by poisoned PTEs.

(that's essentially always "late kill" mode)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
