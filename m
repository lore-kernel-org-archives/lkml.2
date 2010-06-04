Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0FDNJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 09:09:21 -0400
Received: from ist.d-labs.de ([213.239.218.44]:55668 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab0FDNJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 09:09:20 -0400
Date: Fri, 4 Jun 2010 15:09:01 +0200
From: Florian Mickler <florian@mickler.org>
To: Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@suse.de>, markgross@thegnar.org,
       640e9920@gmail.com, Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100604150901.50a115e1@schatten.dmk.lab>
In-Reply-To: <AANLkTimiIyT2TxV5BhhtXwKNKUN9Pa5Bl8YtcoJpHNsw@mail.gmail.com>
References: <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
	<AANLkTikvuqtcGS1UdePRxipSk4S5Vmci2uPfFtzZgx6X@mail.gmail.com>
	<1275575794.5914.74.camel@mulgrave.site>
	<201006032305.58082.rjw@sisk.pl>
	<AANLkTimiIyT2TxV5BhhtXwKNKUN9Pa5Bl8YtcoJpHNsw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 21:07:07 -0700
Arve Hjønnevåg <arve@android.com> wrote:

> On Thu, Jun 3, 2010 at 2:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday 03 June 2010, James Bottomley wrote:
> >> On Thu, 2010-06-03 at 00:10 -0700, Arve Hjønnevåg wrote:
> >> > A request update then becomes something like this:
> >> >   if on primary list {
> >> >     unlink from primary list
> >> >     if secondary list is not empty
> >> >       get next secondary entry and add in same spot on primary list
> >> >   }
> >> >   unlink from secondary list
> >> >   find new spot on primary list
> >> >   if already there
> >> >     add to secondary list
> >> >   else
> >> >     add to primary list
> >>
> >> This is just reinventing hash bucketed lists.  To get the benefits, all
> >> we do is implement an N state constraint as backed by an N bucketed hash
> >> list, which the kernel already has all the internal mechanics for.
> >
> > Agreed.
> >
> 
> No, a hash is used for quick lookup of a specific value, not to find
> an extreme value. It is however extremely similar to plists. The only
> difference is that plists link all the secondary lists together. If we
> want to have constraints that autoexpire, then keeping the secondary
> lists separate allows the same optimization as I did for
> wakelock/suspend_blocker timeouts where no timer is active if an
> (equal or stricter) non-expiring constraint is active.

Can you give an example for the optimization or elaborate about the
negative effect of linking the secondary lists together? I don't
understand right now.

Would be hlist from list.h better? (I think that is what James is
referring to?) That is a (single-linked-)list of double-linked-lists. 

Cheers,
Flo
