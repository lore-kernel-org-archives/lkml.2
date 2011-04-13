Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1DMChq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:37:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55910 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1DMCho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jKQObL4NnpUPo6rPJU/Ds7yr3B8ABypt7nqH5QSUbsCNBD4GMU+ph69fGZw1RF+Tyi
         F6Z/Y1N+mjkrlaD4WCaixicGVoCBhs8Mse3pSnP106UkeGrlYdrn6DePNfnNbeNPZYdm
         pKfACI8vslCCllwhRHHLoX/RLxTnR8kiQJGW8=
Subject: Re: Regression from 2.6.36
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Changli Gao <xiaosuo@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20110412183132.a854bffc.akpm@linux-foundation.org>
References: <20110315132527.130FB80018F1@mail1005.cent>
	 <20110317001519.GB18911@kroah.com> <20110407120112.E08DCA03@pobox.sk>
	 <4D9D8FAA.9080405@suse.cz>
	 <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>
	 <1302177428.3357.25.camel@edumazet-laptop>
	 <1302178426.3357.34.camel@edumazet-laptop>
	 <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
	 <1302190586.3357.45.camel@edumazet-laptop>
	 <20110412154906.70829d60.akpm@linux-foundation.org>
	 <BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>
	 <20110412183132.a854bffc.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 04:37:36 +0200
Message-ID: <1302662256.2811.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 12 avril 2011 à 18:31 -0700, Andrew Morton a écrit :
> On Wed, 13 Apr 2011 09:23:11 +0800 Changli Gao <xiaosuo@gmail.com> wrote:
> 
> > On Wed, Apr 13, 2011 at 6:49 AM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > >
> > > It's somewhat unclear (to me) what caused this regression.
> > >
> > > Is it because the kernel is now doing large kmalloc()s for the fdtable,
> > > and this makes the page allocator go nuts trying to satisfy high-order
> > > page allocation requests?
> > >
> > > Is it because the kernel now will usually free the fdtable
> > > synchronously within the rcu callback, rather than deferring this to a
> > > workqueue?
> > >
> > > The latter seems unlikely, so I'm thinking this was a case of
> > > high-order-allocations-considered-harmful?
> > >
> > 
> > Maybe, but I am not sure. Maybe my patch causes too many inner
> > fragments. For example, when asking for 5 pages, get 8 pages, and 3
> > pages are wasted, then memory thrash happens finally.
> 
> That theory sounds less likely, but could be tested by using
> alloc_pages_exact().
> 

Very unlikely, since fdtable sizes are powers of two, unless you hit
sysctl_nr_open and it was changed (default value being 2^20)




