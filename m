Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab2JQOB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:01:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41911 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab2JQOB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:01:28 -0400
Subject: Re: [PATCH] rcu: restore correct batch limiting
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAJd=RBD1LKiQecdrK67w+Wn=P1mMfRv6JERWUjxpAthm_p+LzA@mail.gmail.com>
References: <1350458052.26103.31.camel@edumazet-glaptop>
	 <CAJd=RBD1LKiQecdrK67w+Wn=P1mMfRv6JERWUjxpAthm_p+LzA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Oct 2012 16:01:22 +0200
Message-ID: <1350482482.26103.495.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 21:18 +0800, Hillf Danton wrote:

> >                                         /* did other CPU force QS recently? */
> > -       long            blimit;         /* Upper limit on a processed batch */
> > +       int             blimit;         /* Upper limit on a processed batch */
> >
> >         /* 3) dynticks interface. */
> > +       int             dynticks_snap;  /* Per-GP tracking for dynticks. */
> >         struct rcu_dynticks *dynticks;  /* Shared per-CPU dynticks state. */
> > -       int dynticks_snap;              /* Per-GP tracking for dynticks. */
> 
> Hm, no words in change log for shuffling dynticks_snap...

I dont like adding two 32bit holes on a structure ;)

This kind of trivial things dont need a changelog, especially when
fixing a critical bug.

I let Paul add this if he really wants.


