Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1BOWVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:21:21 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22941 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab1BOWVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:21:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=HAHBtwnoAlvGP4rP5iCeCZ7xkWy60rzQPxhBUvCXVvaoz9PkahmppFIXGT5Sic6kmj
         JzcvD/m2UM10N85YVtyg==
Date: Tue, 15 Feb 2011 14:21:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
        casteyde.christian@free.fr, Changli Gao <xiaosuo@gmail.com>,
        Vegard Nossum <vegardno@ifi.uio.no>,
        David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [Bugme-new] [Bug 27212] New: Warning kmemcheck: Caught 64-bit
 read from uninitialized memory in netlink_broadcast_filtered
In-Reply-To: <AANLkTinKTdeO5mnE38n==aZMz5P1XKKM+kykhoBu0=9k@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1102151403170.10742@chino.kir.corp.google.com>
References: <bug-27212-10286@https.bugzilla.kernel.org/> <20110120122549.85863a84.akpm@linux-foundation.org> <1295556085.2613.22.camel@edumazet-laptop> <4D393A99.9060104@kernel.org> <1297704922.2996.60.camel@edumazet-laptop>
 <AANLkTinKTdeO5mnE38n==aZMz5P1XKKM+kykhoBu0=9k@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Pekka Enberg wrote:

> > [PATCH] slub: fix kmemcheck calls to match ksize() hints
> >
> > Recent use of ksize() in network stack (commit ca44ac38 : net: don't
> > reallocate skb->head unless the current one hasn't the needed extra size
> > or is shared) triggers kmemcheck warnings, because ksize() can return
> > more space than kmemcheck is aware of.
> >
> > Pekka Enberg noticed SLAB+kmemcheck is doing the right thing, while SLUB
> > +kmemcheck doesnt.
> >
> > Bugzilla reference #27212
> >
> > Reported-by: Christian Casteyde <casteyde.christian@free.fr>
> > Suggested-by: Pekka Enberg <penberg@kernel.org>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > CC: David Miller <davem@davemloft.net>
> > CC: Changli Gao <xiaosuo@gmail.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>

Acked-by: David Rientjes <rientjes@google.com>
