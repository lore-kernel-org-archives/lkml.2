Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0FCN4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:56:07 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44108 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab0FCN4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:56:05 -0400
Date: Thu, 3 Jun 2010 15:55:52 +0200
From: Florian Mickler <florian@mickler.org>
To: Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: markgross@thegnar.org, Brian Swetland <swetland@google.com>,
       640e9920@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100603155552.24c38afc@schatten.dmk.lab>
In-Reply-To: <AANLkTikvuqtcGS1UdePRxipSk4S5Vmci2uPfFtzZgx6X@mail.gmail.com>
References: <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
	<201005312338.55109.rjw@sisk.pl>
	<20100531232617.GF31155@gvim.org>
	<20100601090737.4bc243d9@schatten.dmk.lab>
	<20100601140519.GC1281@gvim.org>
	<AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
	<20100602133910.GA9106@gvim.org>
	<AANLkTilSU79cnBODXFokzIPB1hRcZBxbwTgTQ59MeKcK@mail.gmail.com>
	<20100603031842.GB11311@gvim.org>
	<AANLkTiks7sQBbDnN6QrtGVqSXLob1qCs7VA12LZAWnfM@mail.gmail.com>
	<20100603054018.GE11311@gvim.org>
	<AANLkTikvuqtcGS1UdePRxipSk4S5Vmci2uPfFtzZgx6X@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 00:10:03 -0700
Arve Hjønnevåg <arve@android.com> wrote:

> On Wed, Jun 2, 2010 at 10:40 PM, mark gross <640e9920@gmail.com> wrote:

> > well I think for a pm_qos class that has boolean dynamic range we can
> > get away with not walking the list on every request update.  we can use
> > a counter, and the list will be for mostly for stats.
> >
> 
> Did you give any thought to my suggestion to only use one entry per
> unique value on the first level list and then use secondary lists of
> identical values. That way if you only have two constraints values the
> list you have to walk when updating a request will never have more
> than two entries regardless of how many total request you have.
> 
> A request update then becomes something like this:
>   if on primary list {
>     unlink from primary list
>     if secondary list is not empty
>       get next secondary entry and add in same spot on primary list
>   }
>   unlink from secondary list
>   find new spot on primary list
>   if already there
>     add to secondary list
>   else
>     add to primary list
> 

Yes. I think that would be good. If we keep the primary list sorted,
then this becomes a nice priority queue implementation which does 
GetMax in constant time and Insert and Delete in logarithmic
complexity to the number of different values.

Cheers,
Flo
