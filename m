Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0DPFdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 01:33:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52552 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab0DPFdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 01:33:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: page_check_references() check low order lumpy  reclaim properly
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       Andreas Mohr <andi@lisas.de>, Jens Axboe <axboe@kernel.dk>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <t2j28c262361004152126t1975cd96kc21e54f3a9e41f82@mail.gmail.com>
References: <20100416115437.27AD.A69D9226@jp.fujitsu.com> <t2j28c262361004152126t1975cd96kc21e54f3a9e41f82@mail.gmail.com>
Message-Id: <20100416143134.27B9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 16 Apr 2010 14:33:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +       /*
> > +        * If we need a large contiguous chunk of memory, or have
> > +        * trouble getting a small set of contiguous pages, we
> > +        * will reclaim both active and inactive pages.
> > +        */
> > +       if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
> > +               sc->lumpy_reclaim = 1;
> > +       else if (sc->order && priority < DEF_PRIORITY - 2)
> > +               sc->lumpy_reclaim = 1;
> > +       else
> > +               sc->lumpy_reclaim = 0;
> 
> How about making new function for readability instead of nesting else?
> int is_lumpy_reclaim(struct scan_control *sc)
> {
> ....
> }
> 
> If you merge patch reduced stack usage of reclaim path, I think it's
> enough alone scan_control argument.
> It's just nitpick. :)
> If you don't mind, ignore, please.

Good opinion. I don't hope introduce the dependency of "reduced stack usage"
series. but I agree that I'll push your proposal later and separately.



