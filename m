Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1GGTMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:12:41 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:41419 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753143Ab1GGTMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:12:40 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: vs4L0p4VM1kv8qqw12ANnMAM02ZBR9CfCTicQLD9pXc4Lu.
 6Uop9hbfuvYekF5U6WHpJoLmqxeOTm8mZqthlYI9iZ7W6vxrZfuMibBgcKgd
 k6JWhG0o5zJHVZrcxlKpAUo0HOPugii2OwPUIz9ZRHJywQuFfdUi.LAcR4dI
 xHK2PdcfHLKKSIvNV37TFZqcTu0ZNKp7Z_Ab1ulti_wbgi_LkHEDiaMz.eCp
 m7msrVJug9Ilp65LWHJpRgef4TIMjw0YxJoJOSYLpKepAyj2wHhwlaRvrs0t
 Kc74Fva5d_Om7BJBRgrQqyM86PggfIvKI1Du0iYklPKFbETVezWERb28GDjR
 izzbXCyQjLjEgd3D8kZ1YMr4R
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 7 Jul 2011 14:12:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>, rientjes@google.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
In-Reply-To: <1310064771.21902.55.camel@jaguar>
Message-ID: <alpine.DEB.2.00.1107071402490.24248@router.home>
References: <20110626193918.GA3339@joi.lan>  <alpine.DEB.2.00.1107072106560.6693@tiger>  <alpine.DEB.2.00.1107071314320.21719@router.home> <1310064771.21902.55.camel@jaguar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Pekka Enberg wrote:

> On Thu, 7 Jul 2011, Pekka Enberg wrote:
> > > Looks good to me. Christoph, David, ?
>
> On Thu, 2011-07-07 at 13:17 -0500, Christoph Lameter wrote:
> > The reason debug code is there is because it is useless overhead typically
> > not needed. There is no point in optimizing the code that is not run in
> > production environments unless there are gross performance issues that
> > make debugging difficult. A performance patch for debugging would have to
> > cause significant performance improvements. This patch does not do that
> > nor was there such an issue to be addressed in the first place.
>
> Is there something technically wrong with the patch? Quoting the patch
> email:
>
>   (Compiling some project with different options)
>                                  make -j12    make clean
>   slub_debug disabled:             1m 27s       1.2 s
>   slub_debug enabled:              1m 46s       7.6 s
>   slub_debug enabled + this patch: 1m 33s       3.2 s
>
>   check_bytes still shows up high, but not always at the top.
>
> That's significant enough speedup for me!

Ok. I had a different set of numbers in mind from earlier posts.

The benefit here comes from accessing memory in larger (word) chunks
instead of byte wise. This is a form of memscan() with inverse matching.

Isnt there an asm optimized version that can do this much better (there is
one for memscan())? Optimizing this in core code by codeing something as
generic as that is not that good since the arch code can deliver better
performance and it seems that this is functionality that could be useful
elsewhere.


