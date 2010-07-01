Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab0GATEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:04:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41648 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab0GATEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:04:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] PM: Make it possible to avoid wakeup events from being lost
Date: Thu, 1 Jul 2010 21:02:27 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>, "Arve Hj??nnev??g" <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201006261514.13491.rjw@sisk.pl> <20100701133208.GA1285@ucw.cz>
In-Reply-To: <20100701133208.GA1285@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007012102.27495.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 01, 2010, Pavel Machek wrote:
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
> 
> I assume that second suspend always succeeds?

The mechanism is one-shot if that's what you're asking for.

> I can't say I quite like the way two sysfs files interact with each
> other, but it is certainly better then wakelocks...
> 
> Maybe we should create sys_suspend()?

Well, one can modify pm-utils to use the new sysfs file quite easily, but it
wouldn't be that easy with sys_suspend() IMO.

Rafael
