Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab0HPJWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 05:22:47 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:54351 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab0HPJWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 05:22:46 -0400
Date: Mon, 16 Aug 2010 18:19:35 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Hugepage migration (v2)
Message-ID: <20100816091935.GB3388@spritzera.linux.bs1.fc.nec.co.jp>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.DEB.2.00.1008110806070.673@router.home>
 <20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp>
 <alpine.DEB.2.00.1008130744550.27542@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008130744550.27542@router.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 07:47:21AM -0500, Christoph Lameter wrote:
> On Thu, 12 Aug 2010, Naoya Horiguchi wrote:
> 
> > > Can you also avoid refcounts being increased during migration?
> >
> > Yes. I think this will be done in above-mentioned refactoring.
> 
> Thats not what I meant. Can you avoid other processors increasing
> refcounts (direct I/O etc?) on any page struct of the huge page while
> migration is running?

In my understanding, in current code "other processors increasing refcount
during migration" can happen both in non-hugepage direct I/O and in hugepage
direct I/O in the similar way (i.e. get_user_pages_fast() from dio_refill_pages()).
So I think there is no specific problem to hugepage.
Or am I missing your point?

>
> > This patch only handles migration under direct I/O.
> > For the opposite (direct I/O under migration) it's not true.
> > I wrote additional patches (later I'll reply to this email)
> > for solving locking problem. Could you review them?
> 
> Sure.
> 
> > (Maybe these patches are beyond the scope of hugepage migration patch,
> > so is it better to propose them separately?)
> 
> Migration with known races is really not what we want in the kernel.

Yes.

Thanks,
Naoya Horiguchi
