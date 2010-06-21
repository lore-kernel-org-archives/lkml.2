Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab0FUUlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:41:17 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53326 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758505Ab0FUUlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:41:04 -0400
Date: Mon, 21 Jun 2010 22:40:23 +0200
From: Florian Mickler <florian@mickler.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100621224023.0b14cde7@schatten.dmk.lab>
In-Reply-To: <Pine.LNX.4.44L0.1006211244140.1687-100000@iolanthe.rowland.org>
References: <20100621073233.3f874ad0@schatten.dmk.lab>
	<Pine.LNX.4.44L0.1006211244140.1687-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 12:54:44 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 21 Jun 2010, Florian Mickler wrote:
> 
> > > > > What happens if an event arrives just before you read
> > > > > /sys/power/wakeup_count, but the userspace consumer doesn't realize
> > > > > there is a new unprocessed event until after the power manager checks
> > > > > it?
> > > 
> > > > I think this is not the kernel's problem.  In this approach the kernel makes it
> > > > possible for the user space to avoid the race.  Whether or not the user space
> > > > will use this opportunity is a different matter.
> > > 
> > > It is _not_ possible for userspace to avoid this race.  Help from the 
> > > kernel is needed.
> > 
> > It is possible if every (relevant) userspace program implements a
> > callback for the powermanager to check if one of it's wakeup-sources
> > got activated.
> > 
> > That way the powermanager would read /sys/power/wakeup_count, then do
> > the roundtrip to all it's registered users and only then suspend. 
> 
> After further thought, there's still a race:

Ah, yes. That's what I meant in my other mail with 'how to determine
that an wake event is in flight'. 

Read this too late.
 
> Alan Stern

Cheers,
Flo
