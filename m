Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab0DBHGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 03:06:44 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:49057 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab0DBHGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 03:06:38 -0400
Date: Fri, 2 Apr 2010 09:06:29 +0200
From: Daniel Mack <daniel@caiaq.de>
To: TAO HU <tghk48@motorola.com>
Cc: linux-mm@kvack.org, Chang Qing-A21550 <Qing.Chang@motorola.com>,
       "Ye Yuan.Bo-A22116" <yuan-bo.ye@motorola.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Question] race condition in mm/page_alloc.c regarding
 page->lru?
Message-ID: <20100402070629.GT30801@buzzloop.caiaq.de>
References: <i2i5f4a33681003312105m4cd42e9ayfe35cc0988c401b6@mail.gmail.com>
 <g2g5f4a33681004012051wedea9538w9da89e210b731422@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g2g5f4a33681004012051wedea9538w9da89e210b731422@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 11:51:33AM +0800, TAO HU wrote:
> On Thu, Apr 1, 2010 at 12:05 PM, TAO HU <tghk48@motorola.com> wrote:
> > We got a panic on our ARM (OMAP) based HW.
> > Our code is based on 2.6.29 kernel (last commit for mm/page_alloc.c is
> > cc2559bccc72767cb446f79b071d96c30c26439b)
> >
> > It appears to crash while going through pcp->list in
> > buffered_rmqueue() of mm/page_alloc.c after checking vmlinux.
> > "00100100" implies LIST_POISON1 that suggests a race condition between
> > list_add() and list_del() in my personal view.
> > However we not yet figure out locking problem regarding page.lru.

I'm sure this is just a memory corruption which is unrelated to code in
the the memory management area. The code there just happens to trigger
it as it is called frequently and is very sensitive to bogus data

Did you see the other thread I started off yesterday?

  http://lkml.indiana.edu/hypermail/linux/kernel/1004.0/00157.html

We could well see the same problem here. Not sure though as any kind of
memory corruption ends up in Ooopses like the ones you see, but it could
be a hint.

Daniel

