Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0HPMUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:20:05 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:42430 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750740Ab0HPMUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:20:03 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: C.juCvEVM1k99g6bxJRaC0P7ZSJjxKS9Jgyefl824LU72az
 8LmW63x.dfal6GAkKiey4Daqk4GYILnOu4Towxsgul54UFU9Od.N7vHGgTbk
 zpauZfra5A0yyv96v4TLS_IliwWOkx_oiOnxIZAbqGjh136UiddVgdWhnVlk
 XFuUDBAWktr_N.VGDijsPI4SRO4awbR49UTyjitsLWKwrg_0jsql8IlJgUQC
 VhwS90C8Sndase9qUVnvL_J5YTiYW
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 16 Aug 2010 07:19:58 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Hugepage migration (v2)
In-Reply-To: <20100816091935.GB3388@spritzera.linux.bs1.fc.nec.co.jp>
Message-ID: <alpine.DEB.2.00.1008160707420.11420@router.home>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com> <alpine.DEB.2.00.1008110806070.673@router.home> <20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp> <alpine.DEB.2.00.1008130744550.27542@router.home>
 <20100816091935.GB3388@spritzera.linux.bs1.fc.nec.co.jp>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010, Naoya Horiguchi wrote:

> In my understanding, in current code "other processors increasing refcount
> during migration" can happen both in non-hugepage direct I/O and in hugepage
> direct I/O in the similar way (i.e. get_user_pages_fast() from dio_refill_pages()).
> So I think there is no specific problem to hugepage.
> Or am I missing your point?

With a single page there is the check of the refcount during migration
after all the references have been removed (at that point the page is no
longer mapped by any process and direct iO can no longer be
initiated without a page fault.

I see that you are running try_to_unmap() from unmap_and_move_huge_page().

I dont see a patch adding huge page support to try_to_unmap though. How
does this work?

