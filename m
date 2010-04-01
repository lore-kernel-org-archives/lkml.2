Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab0DAHVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:21:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39894 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab0DAHV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:21:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       San Mehat <san@google.com>, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, n-horiguchi@ah.jp.nec.com
In-Reply-To: <1270105771.3552.1143.camel@calx>
References: <20100401153428.d49c6345.kamezawa.hiroyu@jp.fujitsu.com> <1270105771.3552.1143.camel@calx>
Message-Id: <20100401161927.BE4F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  1 Apr 2010 16:21:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2010-04-01 at 15:34 +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 1 Apr 2010 15:09:56 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > >
> > > +		pm.pos = 0;
> > > +		start_vaddr += PAGEMAP_WALK_SIZE;
> > > +		end = start_vaddr + PAGEMAP_WALK_SIZE;
> > 
> > Sigh...this is bad..
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > In initial design, walk_page_range() was designed just for walking page table and
> > it didn't require mmap_sem. Now, find_vma() etc.. are used in walk_page_range()
> > and we need mmap_sem around it.
> 
> This looks pretty reasonable. However, it also looks very similar to my
> first version of pagemap (which started with double-buffering). It's
> going to need re-testing to make sure it hasn't reintroduced any
> wrapping, alignment, or off-by-one bugs that have already been ironed
> out once or twice.

OK, I'm looking for your test result. :)

Thanks matt for your contribution!


