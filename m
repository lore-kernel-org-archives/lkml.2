Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab0JHQml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:42:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab0JHQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:42:40 -0400
Subject: Re: Linux 2.6.36-rc7
From: Eric Paris <eparis@redhat.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: John Stoffel <john@stoffel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "agruen@suse.de" <agruen@suse.de>
In-Reply-To: <201010081717.25940.tvrtko.ursulin@sophos.com>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	 <1286486674.2571.16.camel@localhost.localdomain>
	 <19631.15310.568446.991954@quad.stoffel.home>
	 <201010081717.25940.tvrtko.ursulin@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 12:41:46 -0400
Message-ID: <1286556106.2682.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 17:17 +0100, Tvrtko Ursulin wrote:
> On Friday 08 Oct 2010 16:42:06 John Stoffel wrote:

> Priority is also not that great concept. I may have proposed classes or
> something similar at some point, don't remember any more. It would be
> equivalent to having allocated priority ranges, like:
> 
> >1000 - pre-content
> >=100 - access-control
> <100 - content
> 
> Doesn't really solve ordering inside groups so maybe we do not need priorities
> at all just these three classes?

I originally thought of trying to enumerate the types of users and came
up with the same 3 you did.  Then I thought it better to give a general
priority field which we could indicate in documentation something like
those 3 classes (exactly like you did above).  I don't want to hard code
some limited number of types of users into the interface. (ok it's going
to limited, I was thinking 8 bits, but maybe others think we need more?)

As an extreme example going with 3 fixed type of users (and thus
equivalently only 3 priorities) would not allow for hierarchies of
hierarchical storage managers.  What if priority MAX only brought in
enough info for priority MAX-1 to bring in the real file?  If they had
to share the single 'pre-content' priority we have another ordering
problem.

-Eric

