Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab0G0OfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:35:06 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:23145 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756146Ab0G0OfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:35:04 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _uVJN8gVM1kHSYbp9fJf7iRpCPE83jk2qVzlexPNes_C1Yv
 0JFwqukcqk5xlO.H_9RiPl_0hLpGP8j405Ms5wFtKR.OD1khbPWE8D.2Jkqa
 os6HodcipOcD9_ovYUY2F7any4CsrPAxP8_dOPRXKJSRMorp0zhdvzYQ.Pvg
 zZW03ZGqzwRdde0GxCCYOLuKMrPP2Hiw2pwEYu7e5CMGSqF0_l1l1EQmgUCs
 VeHd6prUMJf.5fuEC1RLOzmeU2alQ
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 27 Jul 2010 09:34:59 -0500 (CDT)
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
In-Reply-To: <AANLkTikCsGHshU8v86SQiuO+UZBCbdjOKN=GyJFPb7rY@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1007270929290.28648@router.home>
References: <1280159163-23386-1-git-send-email-minchan.kim@gmail.com> <alpine.DEB.2.00.1007261136160.5438@router.home> <pfn.valid.v4.reply.1@mdm.bga.com> <AANLkTimtTVvorrR9pDVTyPKj0HbYOYY3aR7B-QWGhTei@mail.gmail.com> <pfn.valid.v4.reply.2@mdm.bga.com>
 <20100727171351.98d5fb60.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTikCsGHshU8v86SQiuO+UZBCbdjOKN=GyJFPb7rY@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010, Minchan Kim wrote:

> But in fact I have a concern to use PG_reserved since it can be used
> afterward pfn_valid normally to check hole in non-hole system. So I
> think it's redundant.

PG_reserved is already used to mark pages not handled by the page
allocator (see mmap_init_zone).


