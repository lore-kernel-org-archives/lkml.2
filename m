Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab2JIHIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:08:04 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:35138 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751160Ab2JIHIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:08:02 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Michael Leun <lkml20120218@newton.leun.net>
Subject: Re: [3.5 regression / mcs7830 / bisected] bridge constantly toggeling between disabled and forwarding
Date: Tue, 9 Oct 2012 09:07:24 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120723091504.2d035d28@xenia.leun.net> <20120927173905.GC21025@kroah.com> <20121009071515.607f85a4@xenia.leun.net>
In-Reply-To: <20121009071515.607f85a4@xenia.leun.net>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201210090907.25018.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012, Michael Leun wrote:
> On Thu, 27 Sep 2012 10:39:05 -0700
>
> Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Jul 24, 2012 at 01:36:34AM +0200, Michael Leun wrote:
> > > On Mon, 23 Jul 2012 09:15:04 +0200
> > > Michael Leun <lkml20120218@newton.leun.net> wrote:
> > >
> > > [see issue description below]
> > >
> > > Bisecting yielded
> > >
> > > b1ff4f96fd1c63890d78d8939c6e0f2b44ce3113 is the first bad commit
> > > commit b1ff4f96fd1c63890d78d8939c6e0f2b44ce3113
> > > Author: Ondrej Zary <linux@rainbow-software.org>
> > > Date:   Fri Jun 1 10:29:08 2012 +0000
> > >
> > >     mcs7830: Implement link state detection
> > >
> > >     Add .status callback that detects link state changes.
> > >     Tested with MCS7832CV-AA chip (9710:7830, identified as rev.C
> > > by the driver). Fixes
> > > https://bugzilla.kernel.org/show_bug.cgi?id=28532
> > >
> > >     Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > >
> > > :040000 040000 5480780cb5e75c57122a621fc3bab0108c16be27
> > >
> > > d97efd9cc0a465dff76bcd3a3c547f718f2a5345 M    drivers
> > >
> > >
> > > Reverting that from 3.5 makes the issue go away.
> >
> > Did this ever get resolved in 3.6-rc7 or any older kernel?  I can't
> > revert the patch from 3.5.y unless it's also fixed in Linus's tree.
>
> Please excuse me for answering a bit late.
>
> No, that never got resolved, I still have the problem with 3.6 but I'm
> not shure about the correct solution.
>
> Maybe link state detection just does not work with some of that devices
> and we should have an possibility to enable/disable it per device,
> maybe it can be handeled with an blacklist of not working devices,
> maybe it could be fixed - I do not know and also do not know how to
> find out.
>
> But I'm willing to test.

Does the problem appear only in a bridge? Or the link state detection is 
completely wrong?

-- 
Ondrej Zary
