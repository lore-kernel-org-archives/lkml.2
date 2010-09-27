Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab0I0CRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 22:17:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54726 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab0I0CRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 22:17:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] mm: do not print backtraces on GFP_ATOMIC failures
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1285088427.2617.723.camel@edumazet-laptop>
References: <20100921094638.9910add0.akpm@linux-foundation.org> <1285088427.2617.723.camel@edumazet-laptop>
Message-Id: <20100927110723.6B37.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 27 Sep 2010 11:17:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > @@ -72,7 +72,7 @@ struct vm_area_struct;
> > >  /* This equals 0, but use constants in case they ever change */
> > >  #define GFP_NOWAIT	(GFP_ATOMIC & ~__GFP_HIGH)
> > >  /* GFP_ATOMIC means both !wait (__GFP_WAIT not set) and use emergency pool */
> > > -#define GFP_ATOMIC	(__GFP_HIGH)
> > > +#define GFP_ATOMIC	(__GFP_HIGH | __GFP_NOWARN)
> > >  #define GFP_NOIO	(__GFP_WAIT)
> > >  #define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
> > >  #define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)
> > 
> > A much finer-tuned implementation would be to add __GFP_NOWARN just to
> > the networking call sites.  I asked about this in June and it got
> > nixed:
> > 
> > http://www.spinics.net/lists/netdev/msg131965.html
> > --
> 
> Yes, I remember this particular report was useful to find and correct a
> bug.
> 
> I dont know what to say.
> 
> Being silent or verbose, it really depends on the context ?

At least, MM developers don't want to track network allocation failure
issue. We don't have enough knowledge in this area. To be honest, We 
are unhappy current bad S/N bug report rate ;)

Traditionally, We hoped this warnings help to debug VM issue. but
It haven't happen. We haven't detect VM issue from this allocation
failure report. Instead, We've received a lot of network allocation
failure report.

Recently, The S/N ratio became more bad. If the network device enable
jumbo frame feature, order-2 GFP_ATOMIC allocation is called frequently.
Anybody don't have to assume order-2 allocation can success anytime.

I'm not against accurate warning at all. but I cant tolerate this
semi-random warning steal our time. If anyone will not make accurate
warning, I hope to remove this one completely instead.





