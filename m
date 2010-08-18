Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab0HRHd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:33:59 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:35536 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0HRHdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:33:54 -0400
Date: Wed, 18 Aug 2010 16:32:34 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Hugepage migration (v2)
Message-ID: <20100818073234.GA28961@spritzera.linux.bs1.fc.nec.co.jp>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.DEB.2.00.1008110806070.673@router.home>
 <20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp>
 <alpine.DEB.2.00.1008130744550.27542@router.home>
 <20100816091935.GB3388@spritzera.linux.bs1.fc.nec.co.jp>
 <alpine.DEB.2.00.1008160707420.11420@router.home>
 <20100817023719.GC12736@spritzera.linux.bs1.fc.nec.co.jp>
 <20100817081817.GA28969@spritzera.linux.bs1.fc.nec.co.jp>
 <20100817094007.GA18161@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100817094007.GA18161@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 11:40:08AM +0200, Andi Kleen wrote:
> > When get_user_pages_fast() is called before try_to_unmap(),
> > direct I/O code increments refcount on the target page.
> > Because this refcount is not associated to the mapping,
> > migration code will find remaining refcounts after try_to_unmap()
> > unmaps all mappings. Then refcount check decides migration to fail,
> > so direct I/O is continued safely.
> 
> This would imply that direct IO can make migration fail arbitarily.
> Also not good. Should we add some retries, at least for the soft offline
> case?

Soft offline is kicked from userspace, so the retry logic can be implemented
in userspace. However, currently we can't distinguish migration failure from
"unknown page" error by return value (-EIO in both case for now.)
How about changing return value to -EAGAIN when migration failed?

Thanks,
Naoya Horiguchi
