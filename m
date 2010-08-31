Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0HaBiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 21:38:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34574 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab0HaBiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 21:38:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap system
Cc: kosaki.motohiro@jp.fujitsu.com, Ying Han <yinghan@google.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <AANLkTin4-NomOoNFYCKgi7oE+MCUiC0o0ftAkOwLKez_@mail.gmail.com>
References: <20100831095140.87C7.A69D9226@jp.fujitsu.com> <AANLkTin4-NomOoNFYCKgi7oE+MCUiC0o0ftAkOwLKez_@mail.gmail.com>
Message-Id: <20100831102557.87D3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 31 Aug 2010 10:38:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think both Ying's and Minchan's opnion are right and makes sense.  however I _personally_
> > like Ying version because 1) this version is simpler 2) swap full is very rarely event 3)
> > no swap mounting is very common on HPC. so this version could have a chance to
> > improvement hpc workload too.
> 
> I agree.
> 
> >
> > In the other word, both avoiding unnecessary TLB flush and keeping proper page aging are
> > performance matter. so when we are talking performance, we always need to think frequency
> > of the event.
> 
> Ying's one and mine both has a same effect.
> Only difference happens swap is full. My version maintains old
> behavior but Ying's one changes the behavior. I admit swap full is
> rare event but I hoped not changed old behavior if we doesn't find any
> problem.
> If kswapd does aging when swap full happens, is it a problem?
> We have been used to it from 2.6.28.
> 
> If we regard a code consistency is more important than _unexpected_
> result, Okay. I don't mind it. :)

To be honest, I don't mind the difference between you and Ying's version. because
_practically_ swap full occur mean the application has a bug. so, proper page aging
doesn't help so much. That's the reason why I said I prefer simper. I don't have 
strong opinion. I think it's not big matter.


> But at least we should do more thing to make the patch to compile out
> for non-swap configurable system.

Yes, It makes embedded happy :)



