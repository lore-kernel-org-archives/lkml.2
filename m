Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab0FBKXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:23:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab0FBKXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:23:13 -0400
Date: Wed, 2 Jun 2010 20:23:00 +1000
From: Neil Brown <neilb@suse.de>
To: Florian Mickler <florian@mickler.org>
Cc: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] - race-free suspend. Was: Re: [linux-pm] [PATCH 0/8] 
 Suspend block api (version 8)
Message-ID: <20100602202300.468b73fe@notabene.brown>
In-Reply-To: <20100602105039.068c5e00@schatten.dmk.lab>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
	<201006010005.19554.rjw@sisk.pl>
	<20100601090023.788cabf4@notabene.brown>
	<201006010232.20263.rjw@sisk.pl>
	<20100601113309.609349fd@notabene.brown>
	<alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
	<20100601122012.1edeaf48@notabene.brown>
	<alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
	<20100602153235.340a7852@notabene.brown>
	<AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com>
	<20100602180614.729246ea@notabene.brown>
	<20100602105039.068c5e00@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 10:50:39 +0200
Florian Mickler <florian@mickler.org> wrote:

> On Wed, 2 Jun 2010 18:06:14 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > I cannot imagine why it would take multiple seconds to scan a keypad.
> > Can you explain that?
> > 
> > Do you mean while keys are held pressed?  Maybe you don't get a wake-up event
> > on key-release?  In that case your user-space daemon could block suspend
> > while there are any pressed keys....  confused.
> 
> IIRC, the device sends interrupts only for first key-down and
> last key-up.
> To detect simultaneous key-presses you must actively scan it after the
> first key-down.

That makes sense - thanks.
Presumably the first key-press gets to user-space promptly, so the user-space
suspend daemon can be told not to suspend until the last key-up.

Thanks,
NeilBrown
