Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0EaVp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:45:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35691 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab0EaVp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:45:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Mon, 31 May 2010 23:47:24 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <201005302202.39511.rjw@sisk.pl> <AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
In-Reply-To: <AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005312347.24251.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 May 2010, Arve Hjønnevåg wrote:
> 2010/5/30 Rafael J. Wysocki <rjw@sisk.pl>:
...
> 
> I think it makes more sense to block suspend while wakeup events are
> pending than blocking it everywhere timers are used by code that could
> be called while handling wakeup events or other critical work. Also,
> even if you did block suspend everywhere timers where used you still
> have the race where a wakeup interrupt happens right after you decided
> to suspend. In other words, you still need to block suspend in all the
> same places as with the current opportunistic suspend code, so what is
> the benefit of delaying suspend until idle?

Assume for a while that you don't use suspend blockers, OK?  I realize you
think that anything else doesn't make sense, but evidently some other people
have that opinion about suspend blockers.

Now, under that assumption, I think it _generally_ is reasonable to make the
system go into full suspend if everything (ie. CPUs and I/O) has been idle
for sufficiently long time and there are no QoS requirements that aren't
compatible with full system suspend.

Rafael
