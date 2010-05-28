Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab0E1Nss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:48:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40863 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753661Ab0E1Nsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:48:47 -0400
Date: Fri, 28 May 2010 14:55:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528145526.0ce83c85@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTinVs-YfxCHm7Zees9oq_NYySqI6UFtX57JlsLy-@mail.gmail.com>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com>
	<20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
	<AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com>
	<20100528121636.34be17ad@lxorguk.ukuu.org.uk>
	<AANLkTinVs-YfxCHm7Zees9oq_NYySqI6UFtX57JlsLy-@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you are missing the point. It works fine if the alarm caused
> the wakeup, but if you had just used your system and your inactivity
> timeout expired just as your alarm goes off, the alarm will not wake
> the system, nor does it prevent it from suspending.

As far as I can tell (and its an extremely hard situation to replicate),
this is not true. My laptop sleeps and wakes straight back up.

The following cannot occur on my laptop for simple idling

	Alarm
		Suspend

because the Alarm resets the suspend timer when it is delivered. The wake
pins and wake logic also ensure that the sequence

		Suspend
			Alarm

always causes

		Suspend
			Alarm
		Suspend Finishes
		Resume


> > If I suspend/resume my laptop every time I have a 30 second idle gap I
> > will need a new laptop much sooner than makes me happy.
> >
> 
> Then don't set your inactivity timeout to 30 seconds. I don't see how
> this is relevant.

It's very relevant because it means that considering current laptops is
not that important because they can't do this kind of fast sleep/wakeup

> > I don't claim this is true for a typical mobile phone obviously.
> >
> The only difference on the phone is that we have way more wakeup
> events which makes the race conditions more visible. The race exist on
> your laptop as well.

The number of events is I think only partly relevant. What matters is how
long you wait between idle and suspending. The longer you wait the less
potential you have to end up with an event successfully owned by an
application you are not considering relevant to suspend.

