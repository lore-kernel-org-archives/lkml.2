Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0FSHoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 03:44:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57945 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab0FSHoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 03:44:14 -0400
Date: Sat, 19 Jun 2010 09:44:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/23] pagemap: Avoid unused-but-set variable
Message-ID: <20100619074413.GB18946@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org>
 <20100610111039.ED2B2B1A2B@basil.firstfloor.org>
 <20100618162851.c0878f22.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618162851.c0878f22.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> urgh.  In fact I'd urgh the whole patchset.
> 
> Problem is, anyone who looks at all these random (void) casts is going

There are actually not that many in the patch kit if you read it 
completely. I think that's nearly the only one outside a macro.

> to have a hard time working out why they're there.  This is worsened by
> the long-standing practice wherein some people put unneeded (void) casts all
> over the place due to being traumatised by lint 15 years ago (I think).

It's really the same reason why they used this with lints.

When I tried it first I started complaining about gcc too (I even
filled a gcc bug), then disabled it in my build,
but after some contemplation I found it really finds real bugs.

> 
> Wouldn't it be better to make this stuff self-documenting, so anyone
> who reads the code can immediately see what it's doing, rather than
> scratching their heads over random, seemingly-unneeded casts?
> 
> #define gcc_46_is_a_pita(expr)	((void)(expr))

The warning is really useful and we'll get all used to it.

So I went with the plain cast. Maybe some more comments would
be useful.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
