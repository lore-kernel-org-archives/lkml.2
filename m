Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1HYQbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:31:40 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:36301 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753674Ab1HYQbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:31:38 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8Xb9SaYVM1lFPplR4842T65ojtuym3yZeJ9bawyGqO8gRh7
 dqPUp6RWuDpI5XKvzLHt.6fBC8vuOHLbDpDOlSkR86hNWSg2yB61oCIy9p45
 37mjbSgtdxZCb5yI3NriPebrvfUZkLfQ7oGlHm60O1XCjjzbqKk2NhfQB8iX
 0e92U1a0wnaevfQskPwvnjawHq1s4Pjjn2d8W6gZNkILHStEBgSL5Zob7q4f
 L_pBeteuLIO89S.KyWnLCDgBhMohHmQynXSunxrNXO_Y60146AbvClXi.EIw
 .igvedvvjU1Bafp3Bbu7KRKnADrT6qvVCC7D95y5TZedPcVFIHlww_qNW2Bu
 JRQTtL4jdflkvwIPf1186f4u2LFL5z557TOc8FSjTDqVUplf4ojp405T4.3H
 GigduChjOfr_YhZ73kJkH4g--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 25 Aug 2011 11:31:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
In-Reply-To: <1314289208.3268.4.camel@mulgrave>
Message-ID: <alpine.DEB.2.00.1108251128460.27407@router.home>
References: <1313650253-21794-1-git-send-email-gthelen@google.com>  <20110818144025.8e122a67.akpm@linux-foundation.org>  <1314284272.27911.32.camel@twins>  <alpine.DEB.2.00.1108251009120.27407@router.home> <1314289208.3268.4.camel@mulgrave>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, James Bottomley wrote:

> On Thu, 2011-08-25 at 10:11 -0500, Christoph Lameter wrote:
> > On Thu, 25 Aug 2011, Peter Zijlstra wrote:
> >
> > > On Thu, 2011-08-18 at 14:40 -0700, Andrew Morton wrote:
> > > >
> > > > I think I'll apply it, as the call frequency is low (correct?) and the
> > > > problem will correct itself as other architectures implement their
> > > > atomic this_cpu_foo() operations.
> > >
> > > Which leads me to wonder, can anything but x86 implement that this_cpu_*
> > > muck? I doubt any of the risk chips can actually do all this.
> > > Maybe Itanic, but then that seems to be dying fast.
> >
> > The cpu needs to have an RMW instruction that does something to a
> > variable relative to a register that points to the per cpu base.
> >
> > Thats generally possible. The problem is how expensive the RMW is going to
> > be.
>
> Risc systems generally don't have a single instruction for this, that's
> correct.  Obviously we can do it as a non atomic sequence: read
> variable, compute relative, read, modify, write ... but there's
> absolutely no point hand crafting that in asm since the compiler can
> usually work it out nicely.  And, of course, to have this atomic, we
> have to use locks, which ends up being very expensive.

ARM seems to have these LDREX/STREX instructions for that purpose which
seem to be used for generating atomic instructions without lockes. I guess
other RISC architectures have similar means of doing it?




