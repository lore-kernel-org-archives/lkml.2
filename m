Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab0E0OmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:42:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:58568 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab0E0OmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:42:01 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527143508.GA30117@srcf.ucam.org>
References: <20100526120242.5c9b73ad@schatten.dmk.lab>
	 <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	 <20100526133721.602633b2@schatten.dmk.lab>
	 <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	 <20100526142430.327ccbc4@schatten.dmk.lab>
	 <20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	 <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	 <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	 <20100527140655.GA28048@srcf.ucam.org> <1274970531.27810.5024.camel@twins>
	 <20100527143508.GA30117@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 16:41:57 +0200
Message-ID: <1274971317.27810.5070.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 15:35 +0100, Matthew Garrett wrote:
> On Thu, May 27, 2010 at 04:28:51PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-05-27 at 15:06 +0100, Matthew Garrett wrote:
> > > one way which indicates to the scheduler that tasks in TASK_RUNNING 
> > > should be scheduled, and when the session is idle we set the flag the 
> > > other way and all processes in that cgroup get shifted to 
> > > TASK_INTERRUPTIBLE or something.
> > 
> > What's wrong with simply making the phone beep loudly and displaying:
> > bouncing cows is preventing your phone from sleeping!
> 
> Well, primarily that it's possible to design an implementation where it 
> *doesn't* prevent your phone froms sleeping, but also because a given 
> application may justifiably be preventing your phone from sleeping for a 
> short while. What threshold do you use to determine the difference?

Whatever you want, why would the kernel care?

You can create a whole resource management layer in userspace, with
different privilidge/trust levels. Trusted apps may wake more than
untrusted apps. Who cares.

The thing is, you can easily detect what keeps your cpu from idling.
What you do about it a pure userspace solution.

You can use the QoS stuff to give hints, like don't wake me more than 5
times a minute, if with those hints an app still doesn't meet whatever
criteria are suitable for the current mode, yell at it. Or adjust its
QoS parameters for it.

Heck, for all I care, simply SIGKILL the thing and report it once the
user starts looking at his screen again.
