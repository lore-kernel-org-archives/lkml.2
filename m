Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0G2Rab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 13:30:31 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:36300 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754186Ab0G2Raa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 13:30:30 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: kcfl9IMVM1kpEP2BCIWV0LES5CJIFxcb8DKLP6ln_t7EDkx
 kNAQMz8bzBG2ve703SZfU4QrQShWU5IilgxqAExPuBWwDyRk0vnJRoinRHFZ
 .7llfFHRYSAI6ReUme7HGWWk.ZnaZNcU1xYhrW5uqM1tt14B_f8xaGYeYCgT
 5IUErgBWAMl3MBEQ.m5adHR3t.Oo1XT.n_M4LXnh6RyLi5IxgaKFtebVDw.E
 iA8nRe3bFUbPNmJh.zx5MN05mwA08quXAvbUL
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 29 Jul 2010 12:30:23 -0500 (CDT)
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
In-Reply-To: <20100729170313.GB16420@barrios-desktop>
Message-ID: <alpine.DEB.2.00.1007291222410.17734@router.home>
References: <AANLkTikCsGHshU8v86SQiuO+UZBCbdjOKN=GyJFPb7rY@mail.gmail.com> <alpine.DEB.2.00.1007270929290.28648@router.home> <AANLkTinXmkaX38pLjSBCRUS-c84GqpUE7xJQFDDHDLCC@mail.gmail.com> <alpine.DEB.2.00.1007281005440.21717@router.home>
 <20100728155617.GA5401@barrios-desktop> <alpine.DEB.2.00.1007281158150.21717@router.home> <20100728225756.GA6108@barrios-desktop> <alpine.DEB.2.00.1007291038100.16510@router.home> <20100729161856.GA16420@barrios-desktop> <alpine.DEB.2.00.1007291132210.17734@router.home>
 <20100729170313.GB16420@barrios-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010, Minchan Kim wrote:

> But Russell doesn't want it.
> Please, look at the discussion.
>
> http://www.spinics.net/lists/arm-kernel/msg93026.html
>
> In fact, we didn't determine the approache at that time.
> But I think we can't give up ARM's usecase although sparse model
> dosn't be desinged to the such granularity. and I think this approach

The sparse model goes down to page size memmap granularity. The problem
that you may have is with aligning the maximum allocation unit of the
page allocator with the section size of sparsemem. If you reduce your
maximum allocation units then you can get more granularity.

> can solve ARM's FLATMEM's pfn_valid problem which is doing binar search.

OMG.

