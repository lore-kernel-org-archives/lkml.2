Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab0HaQmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 12:42:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45151 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753345Ab0HaQmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 12:42:10 -0400
Date: Tue, 31 Aug 2010 17:59:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Balbi <me@felipebalbi.com>, Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2]
 input: CMA3000 Accelerometer driver)
Message-ID: <20100831175937.70a59a91@lxorguk.ukuu.org.uk>
In-Reply-To: <20100831161730.GA30947@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
	<20100829184904.GC26209@core.coreip.homeip.net>
	<36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
	<20100830214025.2f9677a1@lxorguk.ukuu.org.uk>
	<20100830204412.GA28711@core.coreip.homeip.net>
	<AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
	<20100830214355.GB28865@core.coreip.homeip.net>
	<AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com>
	<20100830224352.GF28865@core.coreip.homeip.net>
	<20100831104446.321fd4f4@lxorguk.ukuu.org.uk>
	<20100831161730.GA30947@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If non-input uses later need non-input interfaces they can switch to that
> > with an input bridge when there is one and when it happens, which
> > probably won't.
> 
> Would there even be an argument which subsystem to use if IIO->input
> bridge existed today? Because if the answer is "no" then push into input
> is driven by convenience and not because it is the right solution. 

Probably because most of these devices have nothing to do with industrial
I/O at all.

> If application does take something as an input it does not make it
> necessarily a human interface device. By this reasoning cameras should
> be represented as an input devices (why, some applications take input

That's not what I asked. 

> I really believe that input should represent purely human interface
> devices, not arbitrary data acquisition devices.

That tends to make little sense where the API is the same and
applications benefit enormously from consistency. I'd rather have an
input->IIO bridge because that is the real world today !

The question is what does the API make *sense* for. Not what can you use
the API for. Unix (and Linux) are enormously powerful because of the use
of common interfaces and APIs.

So a voltmeter really makes no sense. It's not a set of keys and it
doesn't give X/Y/Z style readings. Nor does a camera. But a lot of things
do fit this to varying degrees.

I'm actually more dubious than Linus about ALS - because ALS tends not
produce 'events' but to be sampled, and there are significant power
implications to unnecessary polling.

See it as a curse of success - because you got the API right and made it
flexible people want to use it. And the more it's used the less special
code is needed in user or kernel space for PDAs and phones - instead they
just work.

> > In a game
> > context can I suggest the Zombies game is an example ?
> 
> I am not familiar with this game, sorry.

It uses GPS and networking to stage an 'in real world' zombie dodging
game.

Alan
