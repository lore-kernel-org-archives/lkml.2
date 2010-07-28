Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0G1RCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:02:21 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:47297 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751894Ab0G1RCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:02:19 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: L61aQ_8VM1n1nNRDGxlIFKZRPUo3gKIiShBJrzxr3llAN0l
 24Vb1wTBOOuG1sZWQKYY7rqisPOdEIyHZleB5qBueTryEYokyoL2y1T1fFKU
 b6cAHcgfw3y6dcq1dZNBMVfyy4v.4Xky4bcCAVyYSGheDie4xNHUd8jMgMeF
 lsIRmPEXUVzzrs2CSCVhatGk5aBycLpdcmH8dJAoTxpl5QXEXenu_Hjf9BaZ
 _2j_DGtm7UDd8KAhgLsBVwPC0uM3l
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 28 Jul 2010 12:02:16 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
In-Reply-To: <20100728155617.GA5401@barrios-desktop>
Message-ID: <alpine.DEB.2.00.1007281158150.21717@router.home>
References: <1280159163-23386-1-git-send-email-minchan.kim@gmail.com> <alpine.DEB.2.00.1007261136160.5438@router.home> <pfn.valid.v4.reply.1@mdm.bga.com> <AANLkTimtTVvorrR9pDVTyPKj0HbYOYY3aR7B-QWGhTei@mail.gmail.com> <pfn.valid.v4.reply.2@mdm.bga.com>
 <20100727171351.98d5fb60.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTikCsGHshU8v86SQiuO+UZBCbdjOKN=GyJFPb7rY@mail.gmail.com> <alpine.DEB.2.00.1007270929290.28648@router.home> <AANLkTinXmkaX38pLjSBCRUS-c84GqpUE7xJQFDDHDLCC@mail.gmail.com>
 <alpine.DEB.2.00.1007281005440.21717@router.home> <20100728155617.GA5401@barrios-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010, Minchan Kim wrote:

> > Simplest scheme would be to clear PageReserved() in all page struct
> > associated with valid pages and clear those for page structs that do not
> > refer to valid pages.
>
> I can't understand your words.
> Clear PG_resereved in valid pages and invalid pages both?

Argh sorry. No. Set PageReserved for pages that do not refer to reserved
pages.

> I guess your code look like that clear PG_revered on valid memmap
> but set PG_reserved on invalid memmap.
> Right?

Right.

> invalid memmap pages will be freed by free_memmap and will be used
> on any place. How do we make sure it has PG_reserved?

Not present memmap pages make pfn_valid fail already since there is no
entry for the page table (vmemmap) or blocks are missing in the sparsemem
tables.

> Maybe I don't understand your point.

I thought we are worrying about holes in the memmap blocks containing page
structs. Some page structs point to valid pages and some are not. The
invalid page structs need to be marked consistently to allow the check.


