Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0DTEaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 00:30:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34291 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab0DTEaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 00:30:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 20 Apr 2010 13:26:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][BUGFIX][PATCH 2/2] memcg: fix file mapped underflow at
 migration (v3)
Message-Id: <20100420132616.ed27f757.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100420132050.3477a717.nishimura@mxp.nes.nec.co.jp>
References: <20100413134207.f12cdc9c.nishimura@mxp.nes.nec.co.jp>
	<20100415120516.3891ce46.kamezawa.hiroyu@jp.fujitsu.com>
	<20100415120652.c577846f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100416193143.5807d114.kamezawa.hiroyu@jp.fujitsu.com>
	<20100419124225.91f3110b.nishimura@mxp.nes.nec.co.jp>
	<20100419131817.f263d93c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100419170701.3864992e.nishimura@mxp.nes.nec.co.jp>
	<20100419172629.dbf65e18.kamezawa.hiroyu@jp.fujitsu.com>
	<20100420132050.3477a717.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 13:20:50 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > > I have one concern for now. Reading the patch, the flag have influence on
> > > only anonymous pages, so we'd better to note it and I feel it strange to
> > > set(and clear) the flag of "old page" always(iow, even when !PageAnon)
> > > in prepare_migration.
> > > 
> > 
> > Hmm...Checking "Only Anon" is simpler ?
> I just thought it was inconsistent that we always set/clear the bit about "old page",
> while we set the bit about "new page" only in PageAnon case.
> 
Ok, look into again.


> > It will have no meanings for migrating
> > file caches, but it may have some meanings for easy debugging. 
> > I think "mark it always but it's used only for anonymous page" is reasonable
> > (if it causes no bug.)
> > 
> Anyway, I don't have any strong objection.
> It's all right for me as long as it is well documented or commented.
> 
Maybe I can post v4, today.

Thanks,
-Kame


