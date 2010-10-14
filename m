Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab0JNRPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 13:15:12 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48463 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753129Ab0JNRPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 13:15:10 -0400
Date: Thu, 14 Oct 2010 12:15:04 -0500
From: Robin Holt <holt@sgi.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Convert max_user_watches to long.
Message-ID: <20101014171504.GA14068@sgi.com>
References: <20101001200143.GR14064@sgi.com>
 <alpine.DEB.2.00.1010011335400.2305@ubuntu>
 <m1vd5ll2hl.fsf@fess.ebiederm.org>
 <alpine.DEB.2.00.1010020701320.1564@davide-laptop>
 <20101004194411.GT14068@sgi.com>
 <alpine.DEB.2.00.1010051841050.1941@ubuntu>
 <20101009075002.GW14068@sgi.com>
 <alpine.DEB.2.00.1010102148430.4151@davide-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010102148430.4151@davide-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 09:49:58PM -0700, Davide Libenzi wrote:
> On Sat, 9 Oct 2010, Robin Holt wrote:
> 
> > @@ -900,11 +902,12 @@ static int ep_insert(struct eventpoll *e
> >  {
> >  	int error, revents, pwake = 0;
> >  	unsigned long flags;
> > +	long user_watches;
> >  	struct epitem *epi;
> >  	struct ep_pqueue epq;
> >  
> > -	if (unlikely(atomic_read(&ep->user->epoll_watches) >=
> > -		     max_user_watches))
> > +	user_watches = atomic_long_read(&ep->user->epoll_watches);
> > +	if (user_watches >= max_user_watches)
> >  		return -ENOSPC;
> 
> Is there a particular reason for adding an extra, otherwise unused, 
> user_watches variable?

Keeps the line length and readability complaints down.  No other
reason.

Robin
