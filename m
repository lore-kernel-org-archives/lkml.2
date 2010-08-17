Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab0HQJkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:40:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52777 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227Ab0HQJkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:40:14 -0400
Date: Tue, 17 Aug 2010 11:40:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Hugepage migration (v2)
Message-ID: <20100817094007.GA18161@basil.fritz.box>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.DEB.2.00.1008110806070.673@router.home>
 <20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp>
 <alpine.DEB.2.00.1008130744550.27542@router.home>
 <20100816091935.GB3388@spritzera.linux.bs1.fc.nec.co.jp>
 <alpine.DEB.2.00.1008160707420.11420@router.home>
 <20100817023719.GC12736@spritzera.linux.bs1.fc.nec.co.jp>
 <20100817081817.GA28969@spritzera.linux.bs1.fc.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817081817.GA28969@spritzera.linux.bs1.fc.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When get_user_pages_fast() is called before try_to_unmap(),
> direct I/O code increments refcount on the target page.
> Because this refcount is not associated to the mapping,
> migration code will find remaining refcounts after try_to_unmap()
> unmaps all mappings. Then refcount check decides migration to fail,
> so direct I/O is continued safely.

This would imply that direct IO can make migration fail arbitarily.
Also not good. Should we add some retries, at least for the soft offline
case?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
