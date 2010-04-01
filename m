Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0DAHJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:09:41 -0400
Received: from waste.org ([173.11.57.241]:47876 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab0DAHJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:09:35 -0400
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
From: Matt Mackall <mpm@selenic.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       San Mehat <san@google.com>, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, n-horiguchi@ah.jp.nec.com
In-Reply-To: <20100401153428.d49c6345.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100401144329.BE42.A69D9226@jp.fujitsu.com>
	 <20100401145509.47f7f1c3.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100401150128.BE45.A69D9226@jp.fujitsu.com>
	 <20100401150956.4f6821c2.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100401153428.d49c6345.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 02:09:31 -0500
Message-ID: <1270105771.3552.1143.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 15:34 +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 1 Apr 2010 15:09:56 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> >
> > +		pm.pos = 0;
> > +		start_vaddr += PAGEMAP_WALK_SIZE;
> > +		end = start_vaddr + PAGEMAP_WALK_SIZE;
> 
> Sigh...this is bad..
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> In initial design, walk_page_range() was designed just for walking page table and
> it didn't require mmap_sem. Now, find_vma() etc.. are used in walk_page_range()
> and we need mmap_sem around it.

This looks pretty reasonable. However, it also looks very similar to my
first version of pagemap (which started with double-buffering). It's
going to need re-testing to make sure it hasn't reintroduced any
wrapping, alignment, or off-by-one bugs that have already been ironed
out once or twice.

-- 
http://selenic.com : development and support for Mercurial and Linux


