Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0ENWV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:21:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:59021 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab0ENWVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:21:55 -0400
Subject: Re: [PATCH 05/35] x86, lmb: Add lmb_find_area_size()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BED7B3E.5020308@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-6-git-send-email-yinghai@kernel.org>
	 <1273803621.21352.368.camel@pasglop>  <4BECEDAA.9070009@oracle.com>
	 <1273824809.21352.584.camel@pasglop>  <4BED7B3E.5020308@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 May 2010 08:20:04 +1000
Message-ID: <1273875604.21352.637.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 09:33 -0700, Yinghai Lu wrote:
> On 05/14/2010 01:13 AM, Benjamin Herrenschmidt wrote:
> > On Thu, 2010-05-13 at 23:28 -0700, Yinghai wrote:
> >   
> >> this just line by line translation from early_res version to lmb
> >> changes
> >>
> >> please focus on lmb core at this point.
> >>     
> > Well, the problem is that you dig into the LMB core with those functions
> > which means I -will- break your stuff if/when I change it, for example
> > to use linked lists.
> >
> >   
> then you should don't even struct lmb, and move the definition from
> lmb.h to lmb.c

Well, figure that it's been considered :-) The only reason it's in lmb.h
is so that we can write things like for_each_lmb() as inlines, but
we could just do lmb_first() and lmb_next() and move it all out of line.

Ben.

> > Besides, the code lacks comments and explanation in the changeset. So
> > please provide that, I'm sure Thomas and Peter also want to understand
> > what's going on in the x86 side of things.
> >
> >   
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


