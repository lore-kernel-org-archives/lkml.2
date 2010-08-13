Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934282Ab0HMMr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 08:47:28 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:31887 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934271Ab0HMMrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 08:47:25 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3EhAEZcVM1nOOSmVH19l2B7OAH4m_OTV5fINHTrKlv3JMJc
 McqX47sJMbi9EpC1EZfWZulU6z472sWdhnGNh3MfFt6JgGN.0bQ4PCx3oiGo
 ZrXQEggF.9g05n1iN5MHtd3vxbmrMjX5.PtIknndISg9UmuCReCvGwBn9DsC
 iMZUuLbuxFSw4a3hu4PqfGwug9ep.c6Z9uIV_wA1yx.VSZL.AoQcJAYkotJp
 N
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 13 Aug 2010 07:47:21 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Hugepage migration (v2)
In-Reply-To: <20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp>
Message-ID: <alpine.DEB.2.00.1008130744550.27542@router.home>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com> <alpine.DEB.2.00.1008110806070.673@router.home> <20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010, Naoya Horiguchi wrote:

> > Can you also avoid refcounts being increased during migration?
>
> Yes. I think this will be done in above-mentioned refactoring.

Thats not what I meant. Can you avoid other processors increasing
refcounts (direct I/O etc?) on any page struct of the huge page while
migration is running?

> This patch only handles migration under direct I/O.
> For the opposite (direct I/O under migration) it's not true.
> I wrote additional patches (later I'll reply to this email)
> for solving locking problem. Could you review them?

Sure.

> (Maybe these patches are beyond the scope of hugepage migration patch,
> so is it better to propose them separately?)

Migration with known races is really not what we want in the kernel.

