Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0E2U0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 16:26:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56848 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093Ab0E2U0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 16:26:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Sat, 29 May 2010 22:27:15 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <201005290024.22915.rjw@sisk.pl> <AANLkTimM7O_k8KVSfMgsB8b_EKQEz0vpYu6pxjedsTcJ@mail.gmail.com>
In-Reply-To: <AANLkTimM7O_k8KVSfMgsB8b_EKQEz0vpYu6pxjedsTcJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005292227.15479.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 May 2010, Arve Hjønnevåg wrote:
> 2010/5/28 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Friday 28 May 2010, Arve Hjønnevåg wrote:
> >> On Fri, May 28, 2010 at 1:44 AM, Florian Mickler <florian@mickler.org> wrote:
> >> > On Thu, 27 May 2010 20:05:39 +0200 (CEST)
> >> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > ...
> >> > To integrate this with the current way of doing things, i gathered it
> >> > needs to be implemented as an idle-state that does the suspend()-call?
> >> >
> >>
> >> I think it is better no not confuse this with idle. Since initiating
> >> suspend will cause the system to become not-idle, I don't think is is
> >> beneficial to initiate suspend from idle.
> >
> > It is, if the following two conditions hold simultaneously:
> >
> > (a) Doing full system suspend is ultimately going to bring you more energy
> >    savings than the (presumably lowest) idle state you're currently in.
> >
> > (b) You anticipate that the system will stay idle for a considerably long time
> >    such that it's worth suspending.
> >
> 
> I still don't think this matters. If you are waiting for in interrupt
> that cannot wake you up from suspend, then idle is not an indicator
> that it is safe to enter suspend. I also don't think you can avoid any
> user-space suspend blockers by delaying suspend until the system goes
> idle since any page fault could cause it to go idle. Therefore I don't
> see a benefit in delaying suspend until idle when the last suspend
> blocker is released (it would only mask possible race conditions).

I wasn't referring to suspend blockers, but to the idea of initiating full
system suspend from idle, which I still think makes sense.  If you are
waiting for an interrupt that cannot wake you from suspend, then
_obviously_ suspend should not be started.  However, if you're not waiting for
such an interrupt and the (a) and (b) above hold, it makes sense to start
suspend from idle.

Thanks,
Rafael
