Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab0L1K2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 05:28:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:43250 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab0L1K2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 05:28:50 -0500
Date: Tue, 28 Dec 2010 11:28:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Synaptics touchpad on Dell Vostro V13
In-Reply-To: <201012151523.09476.dmitry.torokhov@gmail.com>
Message-ID: <alpine.LNX.2.00.1012281124030.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012141547570.15140@pobox.suse.cz> <20101214170027.GA11318@core.coreip.homeip.net> <alpine.LNX.2.00.1012152348440.16569@pobox.suse.cz> <201012151523.09476.dmitry.torokhov@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Dmitry Torokhov wrote:

> > > > Looking at the i8042.debug output, the device is clearly buggy, as it
> > > > 
> > > > doesn't identify itself by 0x47 when queried:
> > > > 	91 -> i8042 (command) [58]
> > > > 	e8 -> i8042 (parameter) [58]
> > > > 	fa <- i8042 (interrupt, 3, 12) [59]
> > > > 	91 -> i8042 (command) [59]
> > > > 	00 -> i8042 (parameter) [59]
> > > > 	fa <- i8042 (interrupt, 3, 12) [59]
> > > > 	91 -> i8042 (command) [59]
> > > > 	e8 -> i8042 (parameter) [59]
> > > > 	fa <- i8042 (interrupt, 3, 12) [60]
> > > > 	91 -> i8042 (command) [60]
> > > > 	00 -> i8042 (parameter) [60]
> > > > 	fa <- i8042 (interrupt, 3, 12) [61]
> > > > 	91 -> i8042 (command) [61]
> > > > 	e8 -> i8042 (parameter) [61]
> > > > 	fa <- i8042 (interrupt, 3, 12) [61]
> > > > 	91 -> i8042 (command) [61]
> > > > 	00 -> i8042 (parameter) [61]
> > > > 	fa <- i8042 (interrupt, 3, 12) [62]
> > > > 	91 -> i8042 (command) [62]
> > > > 	e8 -> i8042 (parameter) [62]
> > > > 	fa <- i8042 (interrupt, 3, 12) [63]
> > > > 	91 -> i8042 (command) [63]
> > > > 	00 -> i8042 (parameter) [63]
> > > > 	fa <- i8042 (interrupt, 3, 12) [64]
> > > > 	91 -> i8042 (command) [64]
> > > > 	e9 -> i8042 (parameter) [64]
> > > > 	fa <- i8042 (interrupt, 3, 12) [64]
> > > > 
> > > > ... and here we time out after approximately 0.5s. nomux doesn't really
> > > > fix it, we start getting a lot of timeouts on i8042 with that.
> > > > 
> > > > Apparently the device works with Synaptics driver in Other OS(TM)
> > > > though. Do you have any idea what they might be doing differently so
> > > > that they make the touchpad identify itself properly?
> > > 
> > > Do you have the device in your possession? If so can you check if the
> > > driver installed in Other OS uses active multiplexing? I think you can
> > > infer whether it does or not by looking at the pointer properties - I
> > > think it would "Synaptics Blah at port X" or something like that...
> > 
> > Unfortunately I don't have the hardware myself, it's only bugreport that
> > reached me. I will check this, thanks.
> > 
> > > Also you could try combining nomux with reset and see if it makes any
> > > sense...
> > 
> > Yes, I have already had the reporter to do this, but that's even better --
> > a lot of commands time out, as you can see below
> > 
> >  20 -> i8042 (command) [0]
> >  47 <- i8042 (return) [0]
> >  20 -> i8042 (command) [0]
> >  47 <- i8042 (return) [0]
> >  60 -> i8042 (command) [0]
> >  56 -> i8042 (parameter) [0]
> >  d3 -> i8042 (command) [0]
> >  5a -> i8042 (parameter) [0]
> >  5a <- i8042 (return) [0]
> >  a7 -> i8042 (command) [0]
> >  20 -> i8042 (command) [0]
> >  76 <- i8042 (return) [0]
> >  a8 -> i8042 (command) [0]
> >  20 -> i8042 (command) [0]
> >  56 <- i8042 (return) [0]
> >  60 -> i8042 (command) [0]
> >  56 -> i8042 (parameter) [0]
> >  d3 -> i8042 (command) [0]
> >  a5 -> i8042 (parameter) [0]
> >  a5 <- i8042 (aux_test_irq, aux) [1]
> >  60 -> i8042 (command) [1]
> >  74 -> i8042 (parameter) [1]
> >  60 -> i8042 (command) [1]
> >  56 -> i8042 (parameter) [1]
> >  60 -> i8042 (command) [1]
> >  47 -> i8042 (parameter) [1]
> > serio: i8042 KBD port at 0x60,0x64 irq 1
> > serio: i8042 AUX port at 0x60,0x64 irq 12
> > mice: PS/2 mouse device common for all mice
> >  f2 -> i8042 (kbd-data) [1]
> >  fa <- i8042 (interrupt, 0, 1, timeout) [1]
> >  ab <- i8042 (interrupt, 0, 1, timeout) [1]
> >  83 <- i8042 (interrupt, 0, 1, timeout) [1]
> >  ed -> i8042 (kbd-data) [1]
> >  fa <- i8042 (interrupt, 0, 1, timeout) [1]
> >  00 -> i8042 (kbd-data) [1]
> >  fa <- i8042 (interrupt, 0, 1, timeout) [1]
> >  f3 -> i8042 (kbd-data) [1]
> >  fa <- i8042 (interrupt, 0, 1, timeout) [1]
> >  00 -> i8042 (kbd-data) [1]
> >  fa <- i8042 (interrupt, 0, 1, timeout) [1]
> >  f4 -> i8042 (kbd-data) [1]
> >  fa <- i8042 (interrupt, 0, 1, timeout) [1]
> > input: AT Translated Set 2 keyboard as
> > /devices/platform/i8042/serio0/input/input0 d4 -> i8042 (command) [2]
> >  f2 -> i8042 (parameter) [2]
> >  fa <- i8042 (interrupt, 1, 12, timeout) [2]
> >  00 <- i8042 (interrupt, 1, 12, timeout) [3]
> >  60 -> i8042 (command) [3]
> >  45 -> i8042 (parameter) [3]
> >  60 -> i8042 (command) [3]
> >  47 -> i8042 (parameter) [3]
> >  d4 -> i8042 (command) [3]
> >  f2 -> i8042 (parameter) [3]
> >  fa <- i8042 (interrupt, 1, 12, timeout) [4]
> >  60 -> i8042 (command) [4]
> >  45 -> i8042 (parameter) [4]
> >  60 -> i8042 (command) [4]
> >  47 -> i8042 (parameter) [4]
> >  00 <- i8042 (interrupt, 1, 12, timeout) [5]
> > 
> > ...
> > 
> >  f3 -> i8042 (kbd-data) [6323]
> >  fa <- i8042 (interrupt, 0, 1, timeout) [6323]
> >  20 -> i8042 (kbd-data) [6323]
> >  fa <- i8042 (interrupt, 0, 1, timeout) [6323]
> >  2d <- i8042 (interrupt, 0, 1, timeout) [10631]
> >  10 <- i8042 (interrupt, 0, 1, timeout) [10669]
> >  ad <- i8042 (interrupt, 0, 1, timeout) [10674]
> >  90 <- i8042 (interrupt, 0, 1, timeout) [10692]
> >  2f <- i8042 (interrupt, 0, 1, timeout) [10737]
> >  af <- i8042 (interrupt, 0, 1, timeout) [10760]
> >  17 <- i8042 (interrupt, 0, 1, timeout) [10922]
> >  97 <- i8042 (interrupt, 0, 1, timeout) [10945]
> >  12 <- i8042 (interrupt, 0, 1, timeout) [10998]
> >  92 <- i8042 (interrupt, 0, 1, timeout) [11025]
> >  13 <- i8042 (interrupt, 0, 1, timeout) [11317]
> >  93 <- i8042 (interrupt, 0, 1, timeout) [11345]
> >  1c <- i8042 (interrupt, 0, 1, timeout) [11422]
> >  9c <- i8042 (interrupt, 0, 1, timeout) [11449]
> >  31 <- i8042 (interrupt, 0, 1, timeout) [11672]
> >  b1 <- i8042 (interrupt, 0, 1, timeout) [11697]
> >  18 <- i8042 (interrupt, 0, 1, timeout) [11704]
> >  98 <- i8042 (interrupt, 0, 1, timeout) [11729]
> >  2f <- i8042 (interrupt, 0, 1, timeout) [11800]
> >  af <- i8042 (interrupt, 0, 1, timeout) [11821]
> >  12 <- i8042 (interrupt, 0, 1, timeout) [11842]
> >  92 <- i8042 (interrupt, 0, 1, timeout) [11866]
> >  27 <- i8042 (interrupt, 0, 1, timeout) [11951]
> >  a7 <- i8042 (interrupt, 0, 1, timeout) [11969]
> >  0e <- i8042 (interrupt, 0, 1, timeout) [12061]
> >  8e <- i8042 (interrupt, 0, 1, timeout) [12089]
> >  26 <- i8042 (interrupt, 0, 1, timeout) [12169]
> >  a6 <- i8042 (interrupt, 0, 1, timeout) [12187]
> >  26 <- i8042 (interrupt, 0, 1, timeout) [12207]
> >  a6 <- i8042 (interrupt, 0, 1, timeout) [12227]
> >  1c <- i8042 (interrupt, 0, 1, timeout) [12428]
> >  9c <- i8042 (interrupt, 0, 1, timeout) [12456]
> > 
> > ... and a lot of other timeouts.
> 
> Hmm, and what happens if you force dfl = 0 in i8042_interrupt()? It looks
> like controller FW screwed up...

Yeah, that makes the thing work correctly (together with nomux). This all 
is really strange, isn't it? I doubt other OS discards I8042_STR_TIMEOUT 
completely :)

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
