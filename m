Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0GAPJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:09:00 -0400
Received: from ist.d-labs.de ([213.239.218.44]:35586 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0GAPI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:08:58 -0400
Date: Thu, 1 Jul 2010 17:08:04 +0200
From: Florian Mickler <florian@mickler.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>, Arve Hj??nnev??g <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PM: Make it possible to avoid wakeup events from being
 lost
Message-ID: <20100701170804.687d9604@schatten.dmk.lab>
In-Reply-To: <20100701133208.GA1285@ucw.cz>
References: <201006261514.13491.rjw@sisk.pl>
	<20100701133208.GA1285@ucw.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010 15:32:08 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > @@ -114,3 +114,17 @@ Description:
> >  		if this file contains "1", which is the default.  It may be
> >  		disabled by writing "0" to this file, in which case all devices
> >  		will be suspended and resumed synchronously.
> > +
> > +What:		/sys/power/wakeup_count
> > +Date:		July 2010
> > +Contact:	Rafael J. Wysocki <rjw@sisk.pl>
> > +Description:
> > +		The /sys/power/wakeup_count file allows user space to avoid
> > +		losing wakeup events when transitioning the system into a sleep
> > +		state.  Reading from it returns the current number of registered
> > +		wakeup events and it blocks if some wakeup events are being
> > +		processed at the time the file is read from.  Writing to it
> > +		will only succeed if the current number of wakeup events is
> > +		equal to the written value and, if successful, will make the
> > +		kernel abort a subsequent transition to a sleep state if any
> > +		wakeup events are reported after the write has returned.


> I can't say I quite like the way two sysfs files interact with each
> other, but it is certainly better then wakelocks...

What two files? 

Cheers,
Flo 
