Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0HHTT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 15:19:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51103 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab0HHTTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 15:19:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Sun, 8 Aug 2010 21:17:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
References: <AANLkTinQD3ggLFVd2KvX95U2B_j=ZJquZgiBGieukJ+r@mail.gmail.com> <AANLkTinebiC=9Xd-D_sOwmvA8w_YPWMdhTYz2NRbZ7jH@mail.gmail.com> <AANLkTim-a6qHL_Xo+iVUW4p79EMMRssa0-AqZenNSYJr@mail.gmail.com>
In-Reply-To: <AANLkTim-a6qHL_Xo+iVUW4p79EMMRssa0-AqZenNSYJr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008082117.39082.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 07, 2010, Arve Hjønnevåg wrote:
> 2010/8/7 Arve Hjønnevåg <arve@android.com>:
> > 2010/8/7 Rafael J. Wysocki <rjw@sisk.pl>:
> >> On Saturday, August 07, 2010, Arve Hjønnevåg wrote:
> >>> 2010/8/6 Alan Stern <stern@rowland.harvard.edu>:
> >>> > On Thu, 5 Aug 2010, Arve Hjønnevåg wrote:
> ...
> >>> >> total_time, total time the wake lock has been active. This one should
> >>> >> be obvious.
> >>> >
> >>> > Also easily added.
> >>> >
> >>> Only with a handle passed to all the calls.
> >>
> >> Well, I'm kind of tired of this "my solution is the only acceptable one"
> >> mindset.  IMHO, it's totally counter productive.
> >>
> >
> > How do you propose to track how long a driver has blocked suspend when
> > you have an unblock call that takes no arguments.
> >
> 
> Also, I did not not see a response to my question about why you don't
> want to pass a handle.

It doesn't really matter what I personally want.  In fact, I'm not totally
opposed to that idea, although there are disadvantages (eg. a "handle"
would really mean a pointer to an object with certain life cycle that needs to
be managed by the caller and it's not that clear to me who should manage the
objects that the PCI wakeup code would pass to pm_wakeup_event(), for one
example).  I sent a pull request for your original patchset to Linus after all. :-)

I said I didn't think "it would fly", meaning that I was afraid the other kernel
developers wouldn't like that change.

The reason why I think so is that you'd like to add a whole new infrastructure
whose only purpose would be debugging that would only be useful to systems
using opportunistic suspend.  That, however, is only Android right now and it
cannot use the mainline kernel for other reasons, so basically we would add
infrastructure that's useful to no one.

Thanks,
Rafael
