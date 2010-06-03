Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab0FCHkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:40:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0FCHj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:39:58 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Mickler <florian@mickler.org>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20100602221309.6da754e7@schatten.dmk.lab>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	 <201005302202.39511.rjw@sisk.pl>
	 <AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
	 <201005312347.24251.rjw@sisk.pl>
	 <AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
	 <alpine.LFD.2.00.1006011411200.2933@localhost.localdomain>
	 <AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
	 <alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
	 <AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
	 <1275471561.27810.30865.camel@twins>
	 <AANLkTilLmAb2c9fQwuguzWtjcHfuTZvPUTbUx7vuwFI6@mail.gmail.com>
	 <1275474088.27810.31000.camel@twins>
	 <20100602221309.6da754e7@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Jun 2010 09:40:02 +0200
Message-ID: <1275550802.27810.34863.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 22:13 +0200, Florian Mickler wrote:
> On Wed, 02 Jun 2010 12:21:28 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:

> Do you switch your pc on and off manually? Sometimes? Really?
> (if not, you are probably a kernel hacker *g*) 

Yeah, when my Radeon GPU locks up the bus _again_, and yeah to replace
parts, but no, not otherwise ;-) But I've been doing that for pretty
much as long as I've had a computer.

> But the rest are usecases that are similar to the suspend-blocker
> usecases. You know that you are not using the machine and going
> through the pain to shut down your machine. You have to do it manually.
> Why? 

Make suspend an idle state and teach apps to go real quiet.

(Then again, that only really works when regular network packets can
wake the machine for my case).

> > This leads to having to sprinkle magic dust (and lots of config options)
> > all over userspace. Something that gets esp interesting with only a
> > boolean interface.
> 
> A userspace daemon could keep track of what applications can be
> ignored. The wordprocessor probably should not keep the system busy. As
> well as a running firefox. 
> 
> It is a hard problem. But we have _no way of deciding any of this in
> the kernel_

Therefore I say, fix the worprocessor to not actually do anything if its
not poked at -- not too hard, wordprocessors really don't need to do
anything on their own, and you can do your last backup cycle when the
window becomes invisible and stop the timer until the document changes
again.

Same for firefox, you can teach it to not render animated gifs and run
javascript for invisible tabs, and once the screen-saver kicks in,
nothing is visible (and with X telling apps their window is visible or
not it knows), so it should go idle all of its own.

Fix the friggin apps, don't kludge with freezing.

You really only ever want to freeze broken apps. And even for those I
would prefer it if I got notified some app is stupid, then I could
either fix it, or choose not to use it.

You can also teach cron to listen to dbus messages telling it about the
screen state and postpone jobs -- but please make that a configurable
thing, I really like all that work done at 4am when I'm (usually) not
around to be bothered by it.

> The problem is there independently of suspend blockers. If the system
> can suspend with network up, then you shure as hell want to suspend
> even if the network is up. So it would actually be a reason for any
> kind of "suspend blockers" scheme. Wouldn't it?

Well, at that point suspend is nothing more than an idle state, and
platform code needs to somehow inform the idle state governor that
active net connections need to prevent that idle state from being used.

If you want to call that suspend blockers, then sure, but its a long way
away from the explicit scheme proposed at the start of this thread.
